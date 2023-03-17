// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/profile/widgets/profile_tile.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/widget_extensions.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void logOut(WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToReminders(BuildContext context) {
    Routemaster.of(context).push('/reminders');
  }

  void navigateToNewSymptoms(BuildContext context) {
    Routemaster.of(context).push('/new-symptoms');
  }

  void navigateToApproval(BuildContext context) {
    Routemaster.of(context).push('/approval-status');
  }

  void navigateToBookmarks(BuildContext context) {
    Routemaster.of(context).push('/bookmarks');
  }

  void showlogOutDialog(WidgetRef ref, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure you want to log out'),
            actions: [
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                  logOut(ref);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Column(
        children: [
          71.sbH,
          AppFadeAnimation(
            delay: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20.sbH,
                      //! header
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      8.sbH,
                      Text(
                        '',
                        style: TextStyle(
                          color: Pallete.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  40.sbW,
                ],
              ),
            ),
          ),

          //! profile photo and name
          AppFadeAnimation(
            delay: 1,
            child: Row(
              children: [
                24.sbW,
                CircleAvatar(
                  radius: 25.w,
                  backgroundColor: Pallete.greyColor,
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                10.sbW,
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          24.sbH,

          Column(
            children: profileItems
                .map(
                  (e) => AppFadeAnimation(
                    delay: e.title == 'My Profile'
                        ? 1
                        : e.title == 'Bookmarks'
                            ? 1.2
                            : 1.4,
                    child: ProfileTile(
                      onTap: () {
                        switch (e.title) {
                          case 'Community Creation Approval':
                            navigateToApproval(context);
                            break;

                          case 'Add new symptoms':
                            navigateToNewSymptoms(context);
                            break;

                          case 'Bookmarks':
                            navigateToBookmarks(context);
                            break;
                        }
                      },
                      icon: e.icon,
                      title: e.title,
                      isSwitch: e.isSwitch,
                      isLogout: e.isLogout,
                      isReactive: e.isReactive,
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),

          AppFadeAnimation(
            delay: 1.6,
            child: ProfileTile(
              onTap: () => showlogOutDialog(ref, context),
              icon: PhosphorIcons.signOutBold,
              title: 'Log out',
              isLogout: true,
              isSwitch: false,
            ),
          ),
          30.sbH,
        ],
      ),
    );
  }
}

class ProfileItem {
  final IconData icon;
  final String title;
  final bool isSwitch;
  final bool isLogout;
  final bool isReactive;
  const ProfileItem({
    required this.icon,
    required this.title,
    required this.isSwitch,
    required this.isLogout,
    required this.isReactive,
  });
}

const profileItems = [
  ProfileItem(
    icon: PhosphorIcons.user,
    title: 'My Profile',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.bookmark,
    title: 'Bookmarks',
    isSwitch: false,
    isLogout: false,
    isReactive: true,
  ),
  ProfileItem(
    icon: PhosphorIcons.moonStars,
    title: 'Dark Theme',
    isSwitch: true,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.appWindow,
    title: 'Community Creation Approval',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
];

// Expanded(
//   child: Center(
//     child: BButton(
//       width: 200.w,
//       onTap: () => showlogOutDialog(ref, context),
//       item: Text(
//         'Log out',
//         style: TextStyle(
//           color: Pallete.whiteColor,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     ),
//   ),
// ),
