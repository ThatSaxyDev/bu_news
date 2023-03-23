// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommunityTile extends ConsumerWidget {
  final String name;
  final Widget yours;

  final String members;
  const CommunityTile({
    super.key,
    required this.name,
    required this.yours,
    required this.members,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: currentTheme.drawerTheme.backgroundColor,
          border: Border.all(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
          boxShadow: [
            BoxShadow(
                color: currentTheme.textTheme.bodyMedium!.color!,
                offset: const Offset(5, 5)),
          ],
          borderRadius: BorderRadius.circular(5.r)),
      padding: EdgeInsets.all(20.h),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              yours,
            ],
          ),
          6.sbH,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(PhosphorIcons.usersThree, size: 18.sp,),
              10.sbW,
              Text(
                members,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
