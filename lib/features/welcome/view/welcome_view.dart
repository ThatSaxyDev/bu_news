import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeView extends ConsumerWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final user = ref.watch(userProvider)!;
    void joinBUSACommunity(
      WidgetRef ref,
      BuildContext context,
    ) {
      ref.read(communityControllerProvider.notifier).joinBUSACommunity(context);
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
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
           Text(
                'Welcome ${user.name}',
                style: TextStyle(fontSize: 25.sp),
              ),
            60.sbH,
            BButton(
              onTap: () => joinBUSACommunity(ref, context),
              item: Text(
                'Continue',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
