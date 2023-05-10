// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/models/verification_model.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
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

class VerificationsTile extends ConsumerStatefulWidget {
  final VerificationModel application;
  final double delay;
  final bool isExtended;
  final double height;
  final void Function()? onTap;
  final Icon icon;
  final void Function()? approve;
  final void Function()? reject;
  final bool isLoading;
  final String status;
  const VerificationsTile({
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
    required this.status,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationsTileState();
}

class _VerificationsTileState extends ConsumerState<VerificationsTile> {
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
        child: ref.watch(getUserProvider(widget.application.userId)).when(
              data: (user) {
                return AnimatedContainer(
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
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(30.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color,
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
                          Row(
                            children: [
                              Container(
                                height: 400.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.application.photoIdCard),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              50.sbW,
                              SizedBox(
                                height: 400.h,
                                width: 400.w,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //! name
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Name: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.sp,
                                            color: currentTheme
                                                .textTheme.bodyMedium!.color,
                                          ),
                                        ),
                                      ],
                                    )),

                                    //! matric no
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'MAtric no: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.application.matricNo,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.sp,
                                            color: currentTheme
                                                .textTheme.bodyMedium!.color,
                                          ),
                                        ),
                                      ],
                                    )),

                                    //! phone
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Phone: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.application.phoneNumber,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.sp,
                                            color: currentTheme
                                                .textTheme.bodyMedium!.color,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          50.sbH,
                          if (widget.status == 'pending')
                            widget.isLoading
                                ? const Loader()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                );
              },
              error: (error, stactrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
