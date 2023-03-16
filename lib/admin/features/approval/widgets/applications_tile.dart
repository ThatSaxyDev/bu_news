// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bu_news/models/application_model.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bu_news/utils/button.dart';

class ApplicationsTile extends ConsumerStatefulWidget {
  final ApplicationModel application;
  final double delay;
  final bool isExtended;
  final double height;
  final void Function()? onTap;
  final Icon icon;
  final void Function()? approve;
  final void Function()? reject;
  final bool isLoading;
  const ApplicationsTile({
    super.key,
    required this.application,
    required this.delay,
    required this.isExtended,
    required this.height,
    this.onTap,
    required this.icon,
    this.approve,
    this.reject,
    required this.isLoading,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApplicationsTileState();
}

class _ApplicationsTileState extends ConsumerState<ApplicationsTile> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return AppFadeAnimation(
      delay: widget.delay,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: widget.height,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: currentTheme.backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(width: 0.5.w),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.application.communityName,
                        style: TextStyle(
                          color: currentTheme.textTheme.bodyMedium!.color,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd()
                            .format(widget.application.createdAt),
                        style: TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: widget.icon,
                      ),
                    ],
                  ),
                  50.sbH,
                  widget.isLoading
                      ? const Loader()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BButton(
                              onTap: widget.approve,
                              width: 200.h,
                              color: Colors.green,
                              text: 'Approve',
                            ),
                            BButton(
                              onTap: widget.reject,
                              width: 200.h,
                              color: Colors.red,
                              text: 'Reject',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
