import 'dart:developer';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/favorite_bloc/favorite_bloc.dart';
import 'package:dating_app/state/home_user_bloc/home_user_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/home_screen/widget/other_profile_details_screen.dart';
import 'package:dating_app/view/home_screen/widget/upgrade_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProfile accUserProfile;
  @override
  void initState() {
    super.initState();
    // Fetch users when the screen is first initialized.
    context.read<HomeUserBloc>().add(FetchHomeAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is GetSuccessState) {
              log("User profile executed----------");

              accUserProfile = state.userProfile;

              log(accUserProfile.name);
            }
          },
        ),
        BlocListener<UserActionsBloc, UserActionsState>(
          listener: (context, state)async {
            if (state is SwipeLimitReachedState) {
                   log('SUCCESS: SwipeLimitReachedState was detected!');
             await showUpgradeSheet(context);
              context.read<UserActionsBloc>().add(SwipeLimitWarningShownEvent());
             context.read<UserActionsBloc>().add(SwipeLimitWarningAcknowledgedEvent());
      log('Reset event dispatched.');
      
            }
          },
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("asset/app_icon.png", scale: 18),
                Text(
                  'PairUp Meet',
                  style: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          body: BlocBuilder<HomeUserBloc, HomeUserState>(
            builder: (context, state) {
              if (state is FetchAllUsersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FetchAllUsersLoadedState) {
                UserProfile p = state.userProfiles[0];
                final List<SwipeItem> swipeItems = state.userProfiles.map((
                  profile,
                ) {
                  return SwipeItem(
                    content: profile,
                    likeAction: () {
                      log("Liked //${profile.name}");
                      log(accUserProfile.name);
                      log(accUserProfile.id);
                      context.read<UserActionsBloc>().add(
                        UserLikeActionEvent(
                          likeUserId: profile.id,
                          likeUserName: profile.name,
                          currentUserId: accUserProfile.id,
                          currentUserName: accUserProfile.name,
                          image: accUserProfile.getImages![0],
                        ),
                      );
                    },
                    nopeAction: () {
                      log("Noped ${profile.name}");
                      context.read<UserActionsBloc>().add(
                        UserDislikeActionEvent(dislikeUserId: profile.id),
                      );
                    },
                    superlikeAction: () {
                      log("Superliked ${profile.name}");
                      context.read<UserActionsBloc>().add(
                        SuperLikeEvent(
                          likeUserId: profile.id,
                          likeUserName: profile.name,
                          currentUserId: accUserProfile.id,
                          currentUserName: accUserProfile.name,
                          image: accUserProfile.getImages![0],
                        ),
                      );
                    },
                  );
                }).toList();

                if (swipeItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No more profiles!",
                      style: GoogleFonts.poppins(color: kWhite),
                    ),
                  );
                }

                final MatchEngine matchEngine = MatchEngine(
                  swipeItems: swipeItems,
                );

                return Column(
                  children: [
                    Expanded(
                      child: SwipeCards(
                        matchEngine: matchEngine,
                        upSwipeAllowed: true,
                        onStackFinished: () {
                          log("Stack Finished");
                        },
                        itemBuilder: (context, i) {
                          final profile = swipeItems[i].content as UserProfile;
                          return ProfileCard(
                            profile: profile,
                            onInfoTap: () {
                              pushNewScreen(
                                context,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                                withNavBar: false,
                                screen: OtherProfileDetailsScreen(
                                  index: i,
                                  userProfile: profile,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            onTap: () {
                              context.read<HomeUserBloc>().add(FetchHomeAllUsers());
                            },
                            asset: 'assets/icons/back.png',
                            color: Colors.yellow,
                          ),
                          _buildActionButton(
                            onTap: () {
                              log(
                                "Noped ${matchEngine.currentItem!.content.name}",
                              );
                              context.read<UserActionsBloc>().add(
                                UserDislikeActionEvent(
                                  dislikeUserId:
                                      matchEngine.currentItem!.content.id,
                                ),
                              );
                            },
                            asset: 'assets/icons/clear.png',
                            color: Colors.red,
                            isLarge: true,
                          ),
                          _buildActionButton(
                            onTap: () {
                              matchEngine.currentItem?.superLike();
                              context.read<UserActionsBloc>().add(
                                SuperLikeEvent(
                                  likeUserId:
                                      matchEngine.currentItem!.content.id,
                                  likeUserName:
                                      matchEngine.currentItem!.content.name,
                                  currentUserId: accUserProfile.id,
                                  currentUserName: accUserProfile.name,
                                  image: accUserProfile.getImages![0],
                                ),
                              );
                            },
                            asset: 'assets/icons/star.png',
                            color: Colors.lightBlueAccent,
                          ),
                          _buildActionButton(
                            onTap: () {
                              matchEngine.currentItem?.like();
                              context.read<UserActionsBloc>().add(
                                UserLikeActionEvent(
                                  likeUserId:
                                      matchEngine.currentItem!.content.id,
                                  likeUserName:
                                      matchEngine.currentItem!.content.name,
                                  currentUserId: accUserProfile.id,
                                  currentUserName: accUserProfile.name,
                                  image: accUserProfile.getImages![0],
                                ),
                              );
                            },
                            asset: 'assets/icons/heart.png',
                            color: Colors.greenAccent,
                            isLarge: true,
                          ),
                          // _buildActionButton(
                          //   onTap: () {},
                          //   asset: 'assets/icons/light.png',
                          //   color: Colors.purple,
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
  

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String asset,
    required Color color,
    bool isLarge = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          height: isLarge ? 60 : 50,
          width: isLarge ? 60 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(isLarge ? 12.0 : 8.0),
              child: Image.asset(asset, color: color, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onInfoTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onInfoTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int _currentPhoto = 0;

  @override
  Widget build(BuildContext context) {
    final int numberPhotos = widget.profile.getImages!.length;
    final bool hasImages = numberPhotos > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Hero(
        tag: "profile_hero_${widget.profile.id}",
        child: Stack(
          children: [
            // Image Container
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
                image: hasImages
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.profile.getImages![_currentPhoto],
                        ),
                      )
                    : null,
              ),
              child: !hasImages
                  ? const Center(
                      child: Icon(Icons.person, color: Colors.white, size: 60),
                    )
                  : null,
            ),
            // Black Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
            // Photo Navigation Taps
            if (hasImages && numberPhotos > 1)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentPhoto > 0) {
                          setState(() => _currentPhoto--);
                        }
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentPhoto < (numberPhotos - 1)) {
                          setState(() => _currentPhoto++);
                        }
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            // Top Status Bars for Photos
            if (hasImages && numberPhotos > 1)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: List.generate(numberPhotos, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // FIX: 'Kred' typo is fixed, and logic simplified.
                              color: _currentPhoto == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            // User Info
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            widget.profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.profile.age.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onInfoTap,
                      icon: const Icon(
                        CupertinoIcons.info_circle_fill,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
