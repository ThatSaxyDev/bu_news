// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';

class ProfileTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final bool? isSwitch;
  final bool? isLogout;
  final void Function()? onTap;
  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.isSwitch = true,
    this.isLogout = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    void toggleTheme(WidgetRef ref) {
      ref.read(themeNotifierProvider.notifier).toggleTheme();
    }

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.only(left: 11.w, right: 19.43.h),
        margin: EdgeInsets.only(bottom: 16.h, left: 24.w, right: 24.w),
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            width: 0.5.w
          )
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25.w,
              color: isLogout == true
                  ? Pallete.thickRed
                  : currentTheme.textTheme.bodyMedium!.color,
            ),
            13.5.sbW,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            isSwitch == true
                ? Switch.adaptive(
                    value: ref.watch(themeNotifierProvider.notifier).mode ==
                        ThemeMode.dark,
                    onChanged: (val) => toggleTheme(ref),
                  )
                : Icon(Icons.arrow_forward_ios_rounded, size: 17.h),
          ],
        ),
      ),
    );
  }
}
