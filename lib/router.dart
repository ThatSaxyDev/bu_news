import 'package:bu_news/features/auth/screens/login_screen.dart';
import 'package:bu_news/features/base_nav_wrapper/views/base_nav_wrapper.dart';
import 'package:bu_news/features/community/views/add_mods_view.dart';
import 'package:bu_news/features/community/views/community_apllication_view.dart';
import 'package:bu_news/features/community/views/community_profile_view.dart';
import 'package:bu_news/features/community/views/community_settings_view.dart';
import 'package:bu_news/features/community/views/edit_community_view.dart';
import 'package:bu_news/features/home/views/home_view.dart';
import 'package:bu_news/features/posts/views/add_post_view.dart';
import 'package:bu_news/features/profile/views/approval_status_view.dart';
import 'package:bu_news/features/profile/views/bookmarks_view.dart';
import 'package:bu_news/features/profile/views/edit_profile_view.dart';
import 'package:bu_news/features/video_spaces/views/video_spaces_view.dart';
import 'package:bu_news/features/welcome/view/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(
  routes: {
    // '/base-nav-wrapper': (_) => const MaterialPage(
    //       child: WelcomeView(),
    //     ),
    '/': (_) => const MaterialPage(
          child: BaseNavWrapper(),
        ),
    '/community-application': (_) => const MaterialPage(
          child: CommunityApplicationView(),
        ),
    '/approval-status': (_) => const MaterialPage(
          child: AppprovalStatusView(),
        ),
    '/add-post': (routeData) => const MaterialPage(
          child: AddPostView(),
        ),
    '/bookmarks': (routeData) => const MaterialPage(
          child: BookmarksView(),
        ),
    // '/create-community': (_) => const MaterialPage(
    //       child: CreateCommunityScreen(),
    //     ),
    '/com/:name': (route) => MaterialPage(
          child: CommnunityProfileView(
            name: route.pathParameters['name']!,
          ),
        ),
    '/com/:name/community-settings/:name': (routeDate) => MaterialPage(
          child: CommunitySettingsView(
            name: routeDate.pathParameters['name']!,
          ),
        ),
    '/com/:name/community-settings/:name/edit-community/:name': (routeData) =>
        MaterialPage(
          child: EditCommunityView(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/com/:name/community-settings/:name/add-mods/:name': (routeData) =>
        MaterialPage(
          child: AddModsView(
            name: routeData.pathParameters['name']!,
          ),
        ),
    // '/user-profile/:uid': (routeData) => MaterialPage(
    //       child: UserProfileScreen(
    //         uid: routeData.pathParameters['uid']!,
    //       ),
    //     ),
    '/edit-profile': (routeData) => const MaterialPage(
          child: EditProfileView(),
        ),
    // // '/add-post': (_) => const MaterialPage(
    // //       child: AddPostScreen(),
    // //     ),
    // '/add-post/:type': (routeData) => MaterialPage(
    //       child: VideoSpacesView(
    //         channelId: routeData.pathParameters['type']!,
    //         videoSpace: ,
    //       ),
    //     ),
    // '/post/:postId/comments': (routeData) => MaterialPage(
    //       child: CommentsScreen(
    //         postId: routeData.pathParameters['postId']!,
    //       ),
    //     ),
    // '/chat-list/:uid': (routeData) => MaterialPage(
    //         child: ChatListScreen(
    //       uid: routeData.pathParameters['uid']!,
    //     )),
  },
);
