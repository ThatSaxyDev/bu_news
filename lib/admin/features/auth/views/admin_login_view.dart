import 'package:bu_news/admin/features/auth/controller/admin_auth_controller.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminLoginScreen extends ConsumerWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(adminAuthControllerProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Center(
          child: isLoading
              ? const Loader()
              : Column(
                  children: [
                    100.sbH,
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: () => signInAsGuest(ref, context),
                    //     child: Text(
                    //       AppTexts.skip,
                    //       style: TextStyle(
                    //         // color: Pallete.whiteColor,
                    //         fontSize: 18.sp,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Spc(h: 15.h),
                    SizedBox(
                      height: 300.h,
                      width: 250.w,
                      child: Image.asset('main_logo'.png),
                    ),
                    60.sbH,
                    AdminGButton(
                      padding: 10.h,
                      item: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 30.w,
                            child: Image.asset('google'.png),
                          ),
                          Text(
                            'Continue With Google',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AdminGButton extends ConsumerWidget {
  // final double height;
  // final double width;
  final double padding;
  // final double radius;
  // final void Function()? onTap;

  final Widget item;
  final bool isFromLogin;
  const AdminGButton({
    Key? key,
    // required this.height,
    // required this.width,
    this.padding = 30,
    this.isFromLogin = true,
    // required this.radius,
    // required this.onTap,

    required this.item,
  }) : super(key: key);

  void signInWithGoogleAdmin(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogleAdmin(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return SizedBox(
      height: 50.h,
      width: 300.w,
      child: ElevatedButton(
        onPressed: () => signInWithGoogleAdmin(context, ref),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5.w),
            borderRadius: BorderRadius.all(
              Radius.circular(35.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: currentTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: padding),
        ),
        child: Center(
          child: item,
        ),
      ),
    );
  }
}
