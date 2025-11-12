// ✅ Import the new v2 SDK
const { onCall } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
const { geohashQueryBounds, distanceBetween } = require("geofire-common");

admin.initializeApp();

const FieldValue = admin.firestore.FieldValue;

// Utility function
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371e3;
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c; // in meters
}

// ✅ Enforce App Check on your callable functions
exports.getHotspotMatches = onCall(
  {
    enforceAppCheck: true, // 🚨 Require valid App Check token
  },
  async (request) => {
    const context = request.auth;
    if (!context) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated."
      );
    }

    const currentUserId = context.uid;
    const firestore = admin.firestore();

    try {
      const currentUserDoc = await firestore
        .collection("users")
        .doc(currentUserId)
        .get();
      const currentUserData = currentUserDoc.data();

      if (!currentUserData || !currentUserData.hotspotMatchEnabled) {
        return {
          success: false,
          message: "Hotspot matching is disabled or profile not found.",
        };
      }

      const currentHotspotId = currentUserData.currentHotspotId;
      const currentHotspotName = currentUserData.currentHotspotName;

      if (!currentHotspotId) {
        return {
          success: true,
          matches: [],
          currentHotspotName: null,
          message: "You are not currently at a defined hotspot.",
        };
      }

      const twoHoursAgo = admin.firestore.Timestamp.fromMillis(
        Date.now() - 2 * 60 * 60 * 1000
      );

      const querySnapshot = await firestore
        .collection("users")
        .where("currentHotspotId", "==", currentHotspotId)
        .where("uid", "!=", currentUserId)
        .where("hotspotMatchEnabled", "==", true)
        .where("hotspotCheckInTime", ">", twoHoursAgo)
        .get();

      const matchedUsers = [];
      for (const doc of querySnapshot.docs) {
        const userData = doc.data();
        delete userData.lastKnownLocation;
        matchedUsers.push({ id: doc.id, ...userData });
      }

      return {
        success: true,
        matches: matchedUsers,
        currentHotspotName: currentHotspotName,
      };
    } catch (error) {
      logger.error("Error in getHotspotMatches:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while fetching hotspot matches.",
        error
      );
    }
  }
);

exports.updateUserHotspotStatus = onCall(
  {
    enforceAppCheck: true, // ✅ Require App Check
  },
  async (request) => {
    const context = request.auth;
    if (!context) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated."
      );
    }

    const userId = context.uid;
    const { latitude, longitude } = request.data;

    if (typeof latitude !== "number" || typeof longitude !== "number") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Latitude and longitude are required numbers."
      );
    }

    const firestore = admin.firestore();
    const userRef = firestore.collection("users").doc(userId);

    try {
      await userRef.update({
        lastKnownLocation: {
          latitude,
          longitude,
          timestamp: FieldValue.serverTimestamp(),
        },
      });

      const HOTSPOT_SEARCH_RADIUS = 200; // meters
      const center = [latitude, longitude];

      const bounds = geohashQueryBounds(center, HOTSPOT_SEARCH_RADIUS);

      let isInHotspot = false;
      let foundHotspot = null;

      const matchingHotspotPromises = bounds.map((b) => {
        return firestore
          .collection("hotspots")
          .orderBy("geohash")
          .startAt(b[0])
          .endAt(b[1])
          .get();
      });

      const snapshots = await Promise.all(matchingHotspotPromises);

      for (const querySnapshot of snapshots) {
        for (const doc of querySnapshot.docs) {
          const hotspot = doc.data();
          const distance = distanceBetween(
            [latitude, longitude],
            [hotspot.latitude, hotspot.longitude]
          );

          if (distance <= hotspot.radius) {
            isInHotspot = true;
            foundHotspot = { id: doc.id, name: hotspot.name };
            break;
          }
        }
        if (isInHotspot) break;
      }

      if (isInHotspot && foundHotspot) {
        await userRef.update({
          currentHotspotId: foundHotspot.id,
          currentHotspotName: foundHotspot.name,
          hotspotCheckInTime: FieldValue.serverTimestamp(),
        });
        return { success: true, message: `Checked into ${foundHotspot.name}` };
      } else {
        await userRef.update({
          currentHotspotId: null,
          currentHotspotName: null,
          hotspotCheckInTime: null,
        });
        return { success: true, message: "Not in a hotspot." };
      }
    } catch (error) {
      logger.error("Error updating hotspot status:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while updating hotspot status.",
        error
      );
    }
  }
);
