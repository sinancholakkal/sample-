import 'dart:developer';
import 'dart:ui';

import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/interest_builder.dart';
import 'package:dating_app/view/widgets/privacy_blur_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemShowScreen extends StatefulWidget {
  final UserProfile userProfile;
  final int index;
  const ItemShowScreen({
    super.key,
    required this.userProfile,
    required this.index,
  });

  @override
  State<ItemShowScreen> createState() => _ItemShowScreenState();
}

class _ItemShowScreenState extends State<ItemShowScreen> {
  late int numberPhotos;
  int currentPhoto = 0;
  late UserProfile accUserProfile;
  @override
  void initState() {
    numberPhotos = widget.userProfile.getImages!.length;
    super.initState();
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
        decoration: BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Hero(
                            tag: "imageTag${widget.index}",
                            child: Stack(
                              children: [
                                //Image adding-----------
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      (MediaQuery.of(context).size.height *
                                          0.6) -
                                      25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        widget
                                            .userProfile
                                            .getImages![currentPhoto],
                                      ),
                                    ),
                                  ),
                                ),
                                if (currentPhoto != 0)
                                  PrivacyBlurCard(
                                    imageUrl: widget
                                        .userProfile
                                        .getImages![currentPhoto],
                                    isMatched: false,
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentPhoto != 0) {
                                            setState(() {
                                              currentPhoto = currentPhoto - 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          height:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.6) -
                                              25,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentPhoto <
                                              (numberPhotos - 1)) {
                                            setState(() {
                                              currentPhoto = currentPhoto + 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          height:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.6) -
                                              25,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width -
                                          20,
                                      height: 6,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: numberPhotos,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, int i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Container(
                                              width:
                                                  ((MediaQuery.of(
                                                        context,
                                                      ).size.width -
                                                      (20 +
                                                          ((numberPhotos + 1) *
                                                              8))) /
                                                  numberPhotos),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 0.5,
                                                ),
                                                color: currentPhoto == i
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                          .withOpacity(0.5),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Material(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(100),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Image.asset(
                                                'assets/icons/arrow_down.png',
                                                scale: 20,
                                                color: Colors.white,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                              child: Row(
                                children: [
                                  //Name display--------
                                  Text(
                                    widget.userProfile.name,
                                    style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  //Age display
                                  Text(
                                    widget.userProfile.age,
                                    style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Km away----------
                            // Padding(
                            // 	padding: const EdgeInsets.symmetric(horizontal: 16),
                            // 	child: Row(
                            // 		children: [
                            // 			Icon(
                            // 				CupertinoIcons.placemark,
                            // 				color: Colors.grey.shade600,
                            // 				size: 15,
                            // 			),
                            // 			const SizedBox(width: 5,),
                            // 			Text(
                            // 				"25 km away",
                            // 				style: TextStyle(
                            // 					color: Colors.grey.shade600,
                            // 					fontWeight: FontWeight.w300,
                            // 					fontSize: 15
                            // 				),
                            // 			),
                            // 		],
                            // 	),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.grey.shade600),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Text(
                                "About Me",
                                style: TextStyle(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                              child: Text(
                                widget.userProfile.bio,
                                style: TextStyle(color: kWhite70, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.grey.shade600),
                            ),
                            InterestBuilderWidget(
                              userInterests: widget.userProfile.interests,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Kgrey800,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          // _matchEngine.currentItem!.nope();
                           log("Noped ${widget.userProfile.name}");
                      context.read<UserActionsBloc>().add(
                        UserDislikeActionEvent(dislikeUserId: widget.userProfile.id),
                      );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/icons/clear.png',
                                color: Theme.of(context).colorScheme.primary,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Material(
                      color: Kgrey800,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        splashColor: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          // _matchEngine.currentItem!.superLike();
                           log("Superliked ${widget.userProfile.name}");
                      context.read<UserActionsBloc>().add(
                        SuperLikeEvent(
                          likeUserId: widget.userProfile.id,
                          likeUserName: widget.userProfile.name,
                          currentUserId: accUserProfile.id,
                          currentUserName: accUserProfile.name,
                          image: accUserProfile.getImages![0],
                        ),
                      );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/star.png',
                                color: Colors.lightBlueAccent,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Material(
                      color: Kgrey800,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () {
                          // _matchEngine.currentItem!.like();
                          context.read<UserActionsBloc>().add(
                            UserLikeActionEvent(
                              likeUserId: widget.userProfile.id,
                              likeUserName: widget.userProfile.name,
                              currentUserId: accUserProfile.id,
                              currentUserName: accUserProfile.name,
                              image: accUserProfile.getImages![0],
                            ),
                          );
                          Navigator.pop(context);
                        },
                        splashColor: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/icons/heart.png',
                                color: Colors.greenAccent,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
