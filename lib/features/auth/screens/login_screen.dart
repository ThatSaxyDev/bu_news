import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                  Container(
                    padding: 20.padH,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      image: DecorationImage(
                          image: AssetImage('log'.png), fit: BoxFit.cover),
                    ),
                    height: 200.h,
                    width: 200.w,
                  ),
                  170.sbH,
                  GButton(
                    padding: 10.h,
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: Image.asset('google'.png),
                        ),
                        15.sbW,
                        Text(
                          'Continue With Google',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: currentTheme.textTheme.bodyMedium!.color,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  20.sbH,
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                    decoration: BoxDecoration(
                        color: Pallete.thickRed,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.warning,
                          color: Pallete.whiteColor,
                          size: 23.sp,
                        ),
                        10.sbW,
                        Text(
                          'Make sure it is your school email',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
