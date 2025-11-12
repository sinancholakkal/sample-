import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SwipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _dailySwipeLimit = 5; // Your limit

  Future<bool> canSwipe() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final userRef = _firestore.collection('user').doc(currentUserId);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) return false;

      final data = snapshot.data()!;
      final int swipeCount = data['dailySwipeCount'] ?? 0;

      final Timestamp? lastSwipe = data['lastSwipeDate'];

      bool isNewDay = true;
      if (lastSwipe != null) {
        final String lastSwipeDay = DateFormat(
          'yyyy-MM-dd',
        ).format(lastSwipe.toDate());
        final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        isNewDay = lastSwipeDay != today;
      }

      if (isNewDay) {
        transaction.update(userRef, {
          'dailySwipeCount': 1,
          'lastSwipeDate': FieldValue.serverTimestamp(),
        });
        return true;
      } else {
        if (swipeCount < _dailySwipeLimit) {
          transaction.update(userRef, {
            'dailySwipeCount': FieldValue.increment(1),
            'lastSwipeDate': FieldValue.serverTimestamp(),
          });
          return true;
        } else {
          return false;
        }
      }
    });
  }

    Future<void> resetDailySwipeCount() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == null) {
      log("Error: Cannot reset swipe count, user not logged in.");
      return;
    }

    final userRef = _firestore.collection('user').doc(currentUserId);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (snapshot.exists) {
          // Unconditionally set dailySwipeCount to 0
          transaction.update(userRef, {
            'dailySwipeCount': 0,
            // You can optionally remove 'lastResetDate' if you don't need it at all,
            // or keep it to indicate the last time *any* reset happened for logging.
            // For a pure "set to 0", it's not strictly necessary.
          });
          log("Daily swipe count for $currentUserId explicitly reset to 0.");
        } else {
          log("User document for $currentUserId does not exist. Cannot reset swipe count.");
        }
      });
    } catch (e) {
      log("Error explicitly resetting daily swipe count for $currentUserId: $e");
    }
  }


}
