import 'dart:async'; // Added for Timer
import 'dart:developer'; // Added for log
import 'package:dating_app/state/ad_bloc/ad_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/loading.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- IMPORTANT: Add these missing imports ---
// Adjust these paths to match your project structure

// Assuming appGradient, kWhite, kWhite70, and primary are defined in app_color.dart
// If not, you might need to define them here or ensure app_color.dart is correct.

Future<void> showUpgradeSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child:
            const UpgradeBottomSheet(), // Uses the new, integrated bottom sheet
      );
    },
  );
}

class UpgradeBottomSheet extends StatefulWidget {
  const UpgradeBottomSheet({super.key});

  @override
  State<UpgradeBottomSheet> createState() => _UpgradeBottomSheetState();
}

class _UpgradeBottomSheetState extends State<UpgradeBottomSheet> {
  // --- AdMob Related Variables ---
  InterstitialAd? _interstitialAd;
  bool showAnimation = false; // For your animation state

  // Timer for the single "Watch Ad" button in this bottom sheet
  Timer? _timer;
  int _timeLeft = 0; // Time in seconds for the cooldown

  // We'll use a single adType for this "Watch Ad" button
  // You can choose 1, 2, or 3 based on your logic, or add more buttons.
  static const int _bottomSheetAdType = 1;

  // --- End AdMob Related Variables ---

  @override
  void initState() {
    super.initState();
    _initAdTimer(); // Initialize timer for this ad slot
    _loadInterstitialAd(); // Pre-load an ad when the bottom sheet opens
  }

  @override
  void dispose() {
    _interstitialAd?.dispose(); // Dispose the ad
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  // --- AdMob Related Methods (Adapted from AdRewardScreen) ---

  /// Initializes the timer state from SharedPreferences when the widget starts.
  Future<void> _initAdTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    const int cooldownDuration = 60; // 60 seconds (1 minute)

    int? timestamp = prefs.getInt('timestamp$_bottomSheetAdType');
    if (timestamp != null) {
      int elapsedSeconds = (currentTime - timestamp) ~/ 1000;
      if (elapsedSeconds < cooldownDuration) {
        setState(() {
          _timeLeft = cooldownDuration - elapsedSeconds;
        });
        _startAdTimer(timestamp);
      } else {
        await prefs.remove('timestamp$_bottomSheetAdType'); // Timer expired
      }
    }
    _checkAnimationVisibility(); // Update animation visibility
  }

  /// Starts a countdown timer for the "Watch Ad" slot.
  void _startAdTimer(int startTime) {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? storedTimestamp = prefs.getInt('timestamp$_bottomSheetAdType');
      const int cooldownDuration = 60;

      // If the stored timestamp has changed or been removed, this timer is stale
      if (storedTimestamp == null || storedTimestamp != startTime) {
        timer.cancel();
        setState(() {
          _timeLeft = 0;
        });
        _checkAnimationVisibility();
        return;
      }

      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedSeconds = (currentTime - storedTimestamp) ~/ 1000;
      int remainingTime = cooldownDuration - elapsedSeconds;

      if (remainingTime <= 0) {
        timer.cancel(); // Stop the timer
        await prefs.remove(
          'timestamp$_bottomSheetAdType',
        ); // Clear the stored timestamp
        setState(() {
          _timeLeft = 0;
        });
        _checkAnimationVisibility();
        _loadInterstitialAd(); // Pre-load a new ad once cooldown is over
      } else {
        setState(() {
          _timeLeft = remainingTime;
        });
      }
    });
  }

  /// Helper to check if the current ad slot's timer is active.
  bool _isAdTimerActive() {
    return _timeLeft > 0;
  }

  /// Updates the `showAnimation` state based on whether the ad cooldown is active.
  void _checkAnimationVisibility() {
    setState(() {
      showAnimation = _timeLeft > 0;
    });
  }

  /// Loads an interstitial ad.
  void _loadInterstitialAd() {
    // You could add a check here to prevent multiple simultaneous ad loads if needed.
    String adUnitId;
    switch (_bottomSheetAdType) {
      case 1:
        adUnitId = 'ca-app-pub-6236667985806581/7882906249';
        break;
      case 2:
        adUnitId = 'ca-app-pub-6236667985806581/7912985979';
        break;
      case 3:
        adUnitId = 'ca-app-pub-6236667985806581/2247436188';
        break;
      default:
        adUnitId =
            'ca-app-pub-3940256099942544/1033173712'; // Use test ID as a fallback
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(), // Use const for AdRequest
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('InterstitialAd loaded for adType $_bottomSheetAdType.');
          flutterToast(msg: "Ad ready to watch!");
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          log(
            'InterstitialAd failed to load for adType $_bottomSheetAdType: $error',
          );
          flutterToast(msg: "Ads failed to load. Please try again.");
          _interstitialAd?.dispose();
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Handles the action when the "Watch Ad" button is clicked.
  Future<void> _onWatchAdButtonClicked() async {
    // 1. Check if ad is on cooldown
    if (_isAdTimerActive()) {
      flutterToast(msg: "Ad is on cooldown. Please wait $_timeLeft seconds.");
      return;
    }

    // 2. Check if ad is loaded
    if (_interstitialAd == null) {
      log('InterstitialAd not loaded. Attempting to load...');
      _loadInterstitialAd(); // Try to load it
      flutterToast(msg: "Ad not ready yet. Please try again in a moment.");
      return;
    }

    // 3. Get user data for API call
    // final NetworkApiServices apiServices = NetworkApiServices();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int currentTime = DateTime.now().millisecondsSinceEpoch;
    //var box = await Hive.openBox('registrationBox');
    // var registrationResponse =
    //     box.get('registrationData') as RegistrationResponseModel?;
    // String? userId = registrationResponse?.registrationdata?.userId;

    // if (userId == null) {
    //   flutterToast(msg: "User not logged in. Cannot add coins.");
    //   return;
    // }

    // 4. Show the ad and set up callbacks
    _interstitialAd?.show();
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        log('Ad dismissed for adType $_bottomSheetAdType.');
        ad.dispose(); // Dispose the ad instance after dismissal
        log("Add completed");
        context.read<AdBloc>().add(AdCompletedAndSwipResetEvent());
        // Start cooldown timer and update UI
        //  await prefs.setInt('timestamp$_bottomSheetAdType', currentTime);
        setState(() {
          _timeLeft = 60; // Set cooldown to 60 seconds
          showAnimation = true;
        });
        _checkAnimationVisibility(); // Re-evaluate animation visibility
        //_startAdTimer(currentTime); // Start the cooldown timer

        // Call API to add coins
        // final response = await apiServices.getPostApiResponse(
        //   ApiEndPoints().freeCoins,
        //   {'uid': userId, 'ads_type': _bottomSheetAdType.toString()},
        // );

        // if (response['error_code'] == "200") {
        //   flutterToast(msg: "Your coins added successfully!", );
        // } else {
        //   flutterToast(
        //       msg: "Failed to add coins: ${response['message'] ?? 'Unknown error'}",
        //       );
        // }
        _interstitialAd = null; // Reset the ad instance
        _loadInterstitialAd(); // Load the next ad for this slot
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Ad failed to show for adType $_bottomSheetAdType: $error');
        ad.dispose(); // Dispose the failed ad
        _interstitialAd = null; // Reset the ad instance
        _loadInterstitialAd(); // Try loading another ad

        flutterToast(msg: "Failed to show ad. Coins not added.");
      },
      onAdImpression: (ad) => log('Ad impression recorded.'),
      onAdShowedFullScreenContent: (ad) =>
          log('Ad showed full screen content.'),
      onAdWillDismissFullScreenContent: (ad) =>
          log('Ad will dismiss full screen content.'),
    );
  }

  // --- End AdMob Related Methods ---

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdBloc, AdState>(
      listener: (context, state) {
        if(state is SwipResetLoadingState){
        //  loadingWidget(context);
        }else if(state is SwipResetedState){
         // Navigator.of(context).pop();
          flutterToast(msg: "You have received extra 5 swipes");
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: appGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              Text(
                "Go Unlimited!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You're out of swipes for today. Upgrade to unlock more features.",
                style: GoogleFonts.poppins(fontSize: 16, color: kWhite70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildFeatureRow(
                icon: CupertinoIcons.heart_fill,
                text: "Unlimited Likes",
              ),
              _buildFeatureRow(
                icon: Icons.replay,
                text: "Rewind Your Last Swipe",
              ),
              _buildFeatureRow(
                icon: CupertinoIcons.eye_fill,
                text: "See Who Likes You",
              ),
              _buildFeatureRow(
                icon: Icons.star_sharp,
                text: "5 Free Super Likes a Week",
              ),
              const SizedBox(
                height: 20,
              ), // Added spacing for the Watch Ad button
              ElevatedButton(
                onPressed: _isAdTimerActive()
                    ? null
                    : _onWatchAdButtonClicked, // Use the correct method
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor:
                      Colors.blueAccent, // Use a distinct color for ad button
                  foregroundColor: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isAdTimerActive()
                      ? 'Ad Cooldown: $_timeLeft s'
                      : 'Watch Ad to Get More Swipes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  flutterToast(msg: "Upgrade feature is coming soon!");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: kWhite,
                  foregroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Upgrade Now",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Not Now",
                  style: GoogleFonts.poppins(
                    color: kWhite70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kWhite, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: kWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
