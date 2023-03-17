import 'package:bu_news/admin/features/auth/views/admin_login_view.dart';
import 'package:bu_news/admin/features/base_nav_wrapper/views/base_nav_wrapper.dart';
import 'package:bu_news/admin/features/home/views/admin_home_view.dart';
import 'package:bu_news/admin/features/posts/views/admin_add_post_type_view.dart';
import 'package:bu_news/features/auth/screens/login_screen.dart';
import 'package:bu_news/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../features/communities/views/create_community_view.dart';

final adminLoggedOutRoute = RouteMap(
    routes: {'/': (_) => const MaterialPage(child: AdminLoginScreen())});

final adminLoggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: AdminBaseNavWrapper(),
        ),
    '/add-post/:type': (routeData) => const MaterialPage(
          child: AdminAddPostTypeView(),
        ),
    '/create-community': (_) => const MaterialPage(
          child: CreateCommunityView(),
        ),
    // '/create-community': (_) => const MaterialPage(
    //       child: CreateCommunityScreen(),
    //     ),
    // '/kom/:name': (route) => MaterialPage(
    //       child: CommnunityScreen(
    //         name: route.pathParameters['name']!,
    //       ),
    //     ),
    // '/mod-tools/:name': (routeDate) => MaterialPage(
    //       child: ModToolsScreen(
    //         name: routeDate.pathParameters['name']!,
    //       ),
    //     ),
    // '/edit-komyuniti/:name': (routeData) => MaterialPage(
    //       child: EditCommunityScreen(
    //         name: routeData.pathParameters['name']!,
    //       ),
    //     ),
    // '/add-mods/:name': (routeData) => MaterialPage(
    //       child: AddModsScreen(
    //         name: routeData.pathParameters['name']!,
    //       ),
    //     ),
    // '/user-profile/:uid': (routeData) => MaterialPage(
    //       child: UserProfileScreen(
    //         uid: routeData.pathParameters['uid']!,
    //       ),
    //     ),
    // '/edit-profile/:uid': (routeData) => MaterialPage(
    //       child: EditProfileScreen(
    //         uid: routeData.pathParameters['uid']!,
    //       ),
    //     ),
    // // '/add-post': (_) => const MaterialPage(
    // //       child: AddPostScreen(),
    // //     ),
    // '/add-post/:type': (routeData) => MaterialPage(
    //       child: AddPostTypeScreen(
    //         type: routeData.pathParameters['type']!,
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
