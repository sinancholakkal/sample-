import 'dart:developer';

import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/location_service.dart';
import 'package:dating_app/services/request_services.dart';
import 'package:dating_app/state/chat_bloc/chat_bloc.dart';
import 'package:dating_app/state/favorite_bloc/favorite_bloc.dart';
import 'package:dating_app/state/request_bloc/request_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/chat_screen.dart/chat_screen.dart';
import 'package:dating_app/view/favorite_screen/favorite_screen.dart';
import 'package:dating_app/view/home_screen/home_screen.dart';
import 'package:dating_app/view/hotsport_screen/hotspot_screen.dart';
import 'package:dating_app/view/notification_screen.dart/notification_screen.dart';
import 'package:dating_app/view/profile_screen.dart/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_cupertino_tabbar/bottom_cupertino_tabbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Make sure to import your app's color constants

class EasyTabbar extends StatefulWidget {
  const EasyTabbar({super.key});

  @override
  State<EasyTabbar> createState() => _EasyTabbarState();
}

class _EasyTabbarState extends State<EasyTabbar> {
  @override
  void dispose() {
    setOffline(AuthService().getCurrentUser()!.uid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomCupertinoTabbar(
      activeColor: primary,
      inactiveColor: kWhite70,

      backgroundColor: bgcard.withOpacity(0.8),

      overrideIconsColor: true,
      onTabPressed: (index, model, nestedNavigator) {
        if (index != model.currentTab) {
          if (index == 3) {
            context.read<RequestBloc>().add(FetchRequestsEvent());
          } else if (index == 2) {
             if (Navigator.canPop(context)) {
              log("can pop");
            } else {
              log("Can't pop");
            }
            context.read<FavoriteBloc>().add(FetchAllFavoritesEvent());
            context.read<UserActionsBloc>().add(SwipeLimitWarningShownEvent());
          } else if (index == 0) {
            if (Navigator.canPop(context)) {
              log("can pop");
            } else {
              log("Can't pop");
            }
          }
          model.changePage(index);
        } else {
          if (nestedNavigator[index]?.currentContext != null) {
            Navigator.of(
              nestedNavigator[index]!.currentContext!,
            ).popUntil((route) => route.isFirst);
          }
        }
      },
      notificationsBadgeColor: Colors.transparent,
      firstActiveIndex: 0,
      children: const [
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          page: HomeScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.chat, size: 30),
            label: "Chat",
          ),
          page: ChatListScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.favorite, size: 30),
            label: "Like",
          ),
          page: FavoritesScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.notifications, size: 30),
            label: "Notification",
          ),
          page: NotificationScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.content_paste_search_rounded, size: 30),
            label: "Hotspot screen",
          ),
          page: Scaffold(body: HotspotScreen()),
        ),

        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.person, size: 30),
            label: "Profile",
          ),
          page: Scaffold(body: ProfileScreen()),
        ),
      ],
    );
  }
}
