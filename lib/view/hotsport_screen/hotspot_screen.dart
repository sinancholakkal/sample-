import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/location_service.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/favorite_screen/widgets/item_show_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For DocumentSnapshot if needed elsewhere
import 'dart:async';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class HotspotScreen extends StatefulWidget {
  const HotspotScreen({super.key});

  @override
  State<HotspotScreen> createState() => _HotspotScreenState();
}

class _HotspotScreenState extends State<HotspotScreen>
    with WidgetsBindingObserver {
  User? currentUser;
  Position? currentPosition;
  StreamSubscription? _nearbyUsersSubscription;
  StreamSubscription? _positionSubscription;
  List<UserProfile> nearbyUserProfiles = []; // Changed to List<UserProfile>
  bool _isLoadingLocation = true;
  String _locationError = '';
  final double searchRadiusMeters = 50.0;
  late UserProfile accUserProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeUserAndLocation();
  }

  @override
  void dispose() {
    _nearbyUsersSubscription?.cancel();
    _positionSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    if (currentUser?.uid != null) {
      setOffline(currentUser!.uid);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (currentUser?.uid == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      print('App is paused or detached. Setting user offline.');
      setOffline(currentUser!.uid);
      _nearbyUsersSubscription?.cancel();
      _positionSubscription?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      print('App is resumed. Re-initializing location and nearby users.');
      _initializeUserAndLocation();
    }
  }

  Future<void> _initializeUserAndLocation() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'User not logged in.';
      });
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoadingLocation = false;
            _locationError = 'Location permissions denied.';
          });
          return;
        }
      }

      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = initialPosition;
        _isLoadingLocation = false;
      });

      await updateUserLocation(currentUser!.uid, initialPosition);
      _startListeningForNearbyUsers();
      _startLocationUpdates();
    } catch (e) {
      print('Error initializing location: $e');
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Failed to get location: ${e.toString()}';
      });
    }
  }

  void _startListeningForNearbyUsers() {
    if (currentUser == null || currentPosition == null) return;

    _nearbyUsersSubscription?.cancel();

    // CALL THE NEW FUNCTION THAT RETURNS USER PROFILES
    _nearbyUsersSubscription =
        getNearbyUsersWithProfiles(
          // Changed function name
          currentUser!.uid,
          currentPosition!,
          searchRadiusMeters,
        ).listen(
          (profiles) {
            // Listens to UserProfile list
            setState(() {
              nearbyUserProfiles = profiles; // Update nearbyUserProfiles
            });
            print('Found ${profiles.length} nearby user profiles.');
          },
          onError: (error) {
            print('Error listening for nearby users: $error');
            setState(() {
              _locationError =
                  'Error fetching nearby users: ${error.toString()}';
            });
          },
        );
  }

  void _startLocationUpdates() {
    _positionSubscription?.cancel();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) async {
            if (currentUser != null && position != currentPosition) {
              setState(() {
                currentPosition = position;
              });
              print(
                'Location updated: ${position.latitude}, ${position.longitude}',
              );
              await updateUserLocation(currentUser!.uid, position);
              _startListeningForNearbyUsers();
            }
          },
          onError: (error) {
            print('Error in location stream: $error');
            setState(() {
              _locationError = 'Error updating location: ${error.toString()}';
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetSuccessState) {
          accUserProfile = state.userProfile;
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Nearby', style: TextStyle(color: kWhite)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: _isLoadingLocation
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _locationError.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _locationError,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : nearbyUserProfiles.isEmpty
              ? const Center(
                  child: Text(
                    'No one nearby yet. Keep exploring!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: nearbyUserProfiles.length,
                  itemBuilder: (context, index) {
                    final UserProfile userProfile = nearbyUserProfiles[index];
                    final String otherUserId = userProfile.id;
                    final String userName = userProfile.name;
                    final String userBio = userProfile.bio;
                    final List<String>? userProfileImageUrls =
                        userProfile.getImages;
                    final double? distance = userProfile.distanceInMeters;

                    String distanceText = 'Unknown distance';
                    if (distance != null) {
                      distanceText =
                          '${distance.toStringAsFixed(0)} meters away';
                    }

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          titleTextStyle: TextStyle(
                            color: kWhite,
                            fontSize: 19,
                          ),
                          subtitleTextStyle: TextStyle(
                            color: kWhite70,
                            fontSize: 16,
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userProfileImageUrls![0],
                            ),
                          ),
                          title: Text(userName),
                          subtitle: Text(distanceText),
                          trailing: IconButton(
                            icon: const Icon(
                              CupertinoIcons.check_mark_circled,
                              color: Colors.greenAccent,
                              size: 30,
                            ),
                            onPressed: () {
                              context.read<UserActionsBloc>().add(
                                UserLikeActionEvent(
                                  likeUserId: userProfile.id,
                                  likeUserName: userProfile.name,
                                  currentUserId: accUserProfile.id,
                                  currentUserName: accUserProfile.name,
                                  image: accUserProfile.getImages![0],
                                ),
                              );
                              setState(() {
                                nearbyUserProfiles.removeAt(index);
                              });
                            },
                          ),
                          onTap: () {
                            pushNewScreen(
                              context,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                              withNavBar: false,
                              screen: ItemShowScreen(
                                userProfile: userProfile,
                                index: 0,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
