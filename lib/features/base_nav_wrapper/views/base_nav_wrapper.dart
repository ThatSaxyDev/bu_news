import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/base_nav_wrapper/widgets/nav_bar_widget.dart';
import 'package:bu_news/features/community/views/community_view.dart';
import 'package:bu_news/features/home/views/home_view.dart';
import 'package:bu_news/features/posts/views/add_post_view.dart';
import 'package:bu_news/features/profile/views/profile_view.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/widget_extensions.dart';
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
    HomeView(),
    CommunityView(),
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
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Scaffold(
      // pages
      body: user.email.contains('@student.babcock.edu.ng')
          ? ValueListenableBuilder(
              valueListenable: _page,
              builder: (context, value, child) => pages[_page.value],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  330.sbH,
                  Icon(
                    PhosphorIcons.warningBold,
                    size: 60.sp,
                  ),
                  15.sbH,
                  Text(
                    'The e-mail address associated with this account is not a Babcock student e-mail',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  200.sbH,
                  InkWell(
                    onTap: () => logOut(ref),
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Pallete.thickRed,
                      child: Icon(
                        Icons.arrow_back,
                        color: Pallete.whiteColor,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

      // nav bar
      bottomNavigationBar: user.email.contains('@student.babcock.edu.ng')
          ? ValueListenableBuilder(
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
                        icon: PhosphorIcons.usersThreeBold,
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
            )
          : null,
    );
  }
}
