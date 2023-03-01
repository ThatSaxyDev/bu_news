import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/base_nav_wrapper/widgets/nav_bar_widget.dart';
import 'package:bu_news/features/profile/views/profile_view.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BaseNavWrapper extends ConsumerStatefulWidget {
  const BaseNavWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseNavWrapperState();
}

class _BaseNavWrapperState extends ConsumerState<BaseNavWrapper> {
  List<Widget> pages = [
    Container(),
    Container(),
    // Container(color: Colors.green),
    // Container(color: Colors.pink),
    // NotesView(),
    // InsightsView(),
    // HomeView(),
    // HelpView(),
    ProfileView(),
  ];

  final ValueNotifier<int> _page = ValueNotifier(0);

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  void initState() {
    super.initState();
    _page.value = 0;
    //  AwesomeNotifications().isNotificationAllowed().then(
    //   (isAllowed) {
    //     if (!isAllowed) {
    //       showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title: const Text('Allow Notifications'),
    //           content:
    //               const Text('Beta Health would like to send you notifications'),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Text(
    //                 'Don\'t Allow',
    //                 style: TextStyle(color: Colors.grey, fontSize: 18.sp),
    //               ),
    //             ),
    //             TextButton(
    //               onPressed: () => AwesomeNotifications()
    //                   .requestPermissionToSendNotifications()
    //                   .then((_) => Navigator.pop(context)),
    //               child: Text(
    //                 'Allow',
    //                 style: TextStyle(
    //                   color: Colors.teal,
    //                   fontSize: 18.sp,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // pages
      body: ValueListenableBuilder(
        valueListenable: _page,
        builder: (context, value, child) => pages[_page.value],
      ),

      // nav bar
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _page,
        builder: (context, value, child) => Material(
          elevation: 5,
          // nav bar content
          child: Container(
            color: currentTheme.backgroundColor,
            padding: EdgeInsets.only(top: 17.h, left: 17.w, right: 17.w),
            height: 80.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //! Notes
                NavBarWidget(
                  onTap: () => _page.value = 0,
                  icon: PhosphorIcons.houseBold,
                  label: '',
                  color: _page.value == 0 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 0 ? FontWeight.w600 : null,
                ),

                //! Insights
                NavBarWidget(
                  onTap: () => _page.value = 1,
                  icon: PhosphorIcons.plusBold,
                  label: '',
                  iconColor: _page.value == 1 ? Pallete.blueColor : null,
                  color: _page.value == 1 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 1 ? FontWeight.w600 : null,
                ),

                //! Home
                NavBarWidget(
                  onTap: () => _page.value = 2,
                  icon: PhosphorIcons.gearBold,
                  label: '',
                  color: _page.value == 2 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 2 ? FontWeight.w600 : null,
                ),

                // //! Help
                // NavBarWidget(
                //   onTap: () => _page.value = 3,
                //   icon: _page.value == 3 ? 'help-filled' : 'help',
                //   label: 'Help',
                //   color: _page.value == 3 ? Pallete.blueColor : null,
                //   fontWeight: _page.value == 3 ? FontWeight.w600 : null,
                // ),

                // //! Profile
                // NavBarWidget(
                //   onTap: () => _page.value = 4,
                //   icon: _page.value == 4 ? 'profile-selected' : 'profile',
                //   label: 'Profile',
                //   color: _page.value == 4 ? Pallete.blueColor : null,
                //   fontWeight: _page.value == 4 ? FontWeight.w600 : null,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
