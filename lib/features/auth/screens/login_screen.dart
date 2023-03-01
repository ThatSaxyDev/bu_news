import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

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
                  SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: Image.asset('main_logo'.png),
                  ),
                  60.sbH,
                  GButton(
                    padding: 10.h,
                    color: Pallete.greyColor,
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
    );
  }
}
