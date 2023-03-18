import 'dart:io';

import 'package:bu_news/core/utils.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/profile/controllers/profile_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  File? bannerFile;
  File? profileFile;
  final TextEditingController matricController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    matricController.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  File? image;
  void selectImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          profileFile: profileFile,
        );
  }

  void requestVerification() {
    ref.read(userProfileControllerProvider.notifier).requestVerification(
          context: context,
          matricNo: matricController.text.trim(),
          photoIdCard: image,
          phoneNumber: phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return ref.watch(getUserProvider(user.uid)).when(
          data: (user) => Scaffold(
            // backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: isLoading
                ? const Loader()
                : SingleChildScrollView(
                    child: SizedBox(
                      height: height(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          children: [
                            20.sbH,
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              FileImage(profileFile!),
                                          radius: 32.r,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user.profilePic),
                                          radius: 32.r,
                                        ),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(PhosphorIcons.cameraFill),
                                ),
                              ],
                            ),
                            40.sbH,
                            //! name
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: currentTheme.backgroundColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(width: 0.5.w)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                          color: currentTheme
                                              .textTheme.bodyMedium!.color,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.name,
                                        style: TextStyle(
                                          color: currentTheme
                                              .textTheme.bodyMedium!.color,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            20.sbH,
                            // mail
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: currentTheme.backgroundColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(width: 0.5.w)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Email: ',
                                        style: TextStyle(
                                          color: currentTheme
                                              .textTheme.bodyMedium!.color,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.email,
                                        style: TextStyle(
                                          color: currentTheme
                                              .textTheme.bodyMedium!.color,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            20.sbH,
                            // if (user.isALead == false)
                            user.schoolName == ''
                                ? Column(
                                    children: [
                                      // matric
                                      TextField(
                                        controller: matricController,
                                        decoration: InputDecoration(
                                            hintText: 'Matric No',
                                            hintStyle:
                                                TextStyle(fontSize: 13.sp),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            contentPadding:
                                                EdgeInsets.all(18.w)),
                                        maxLength: 7,
                                      ),
                                      20.sbH,

                                      // phone
                                       TextField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                            hintText: 'Phone number E.g. 08012345678',
                                            hintStyle:
                                                TextStyle(fontSize: 13.sp),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            contentPadding:
                                                EdgeInsets.all(18.w)),
                                        maxLength: 11,
                                      ),
                                      20.sbH,

                                      //! id upload
                                      GestureDetector(
                                        onTap: selectImage,
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: Radius.circular(15.r),
                                          dashPattern: const [10, 4],
                                          strokeCap: StrokeCap.round,
                                          color: currentTheme
                                              .textTheme.bodyMedium!.color!,
                                          child: Container(
                                            width: double.infinity,
                                            height: 150.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: image != null
                                                ? Image.file(image!)
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Upload Student Id Card',
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        10.sbH,
                                                        Icon(
                                                          PhosphorIcons
                                                              .identificationBadge,
                                                          size: 40.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      90.sbH,
                                      BButton(
                                        height: 60.h,
                                        width: 200.w,
                                        radius: 10.r,
                                        onTap: () => requestVerification(),
                                        color: Pallete.greyColor,
                                        text: 'Request Verification',
                                      ),
                                    ],
                                  )
                                : Consumer(
                                    builder: (context, ref, child) => ref
                                        .watch(getVerificationsProvider)
                                        .when(
                                          data: (verifications) {
                                            if (verifications.isEmpty ||
                                                verifications[0]
                                                        .verificationStatus ==
                                                    'rejected') {
                                              return Column(
                                                children: [
                                                  // matric
                                                  TextField(
                                                    controller:
                                                        matricController,
                                                    decoration: InputDecoration(
                                                        hintText: 'Matric No',
                                                        hintStyle: TextStyle(
                                                            fontSize: 13.sp),
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                18.w)),
                                                    maxLength: 7,
                                                  ),
                                                  20.sbH,

                                                  //! id upload
                                                  GestureDetector(
                                                    onTap: selectImage,
                                                    child: DottedBorder(
                                                      borderType:
                                                          BorderType.RRect,
                                                      radius:
                                                          Radius.circular(15.r),
                                                      dashPattern: const [
                                                        10,
                                                        4
                                                      ],
                                                      strokeCap:
                                                          StrokeCap.round,
                                                      color: currentTheme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color!,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 150.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        child: image != null
                                                            ? Image.file(image!)
                                                            : Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Upload Student Id Card',
                                                                      style:
                                                                          TextStyle(
                                                                        color: currentTheme
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .color,
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    10.sbH,
                                                                    Icon(
                                                                      PhosphorIcons
                                                                          .identificationBadge,
                                                                      size:
                                                                          40.h,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  verifications[0]
                                                          .description
                                                          .isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            20.sbH,
                                                            Text(
                                                              verifications[0]
                                                                  .description,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            35.sbH,
                                                          ],
                                                        )
                                                      : 90.sbH,
                                                  BButton(
                                                    height: 60.h,
                                                    width: 200.w,
                                                    radius: 10.r,
                                                    onTap: () =>
                                                        requestVerification(),
                                                    color: Pallete.greyColor,
                                                    text:
                                                        'Request Verification',
                                                  ),
                                                ],
                                              );
                                            }

                                            return Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Verification Status: ',
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: verifications[0]
                                                              .verificationStatus
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: verifications[
                                                                            0]
                                                                        .verificationStatus ==
                                                                    'approved'
                                                                ? Colors.green
                                                                : verifications[0]
                                                                            .verificationStatus ==
                                                                        'rejected'
                                                                    ? Colors.red
                                                                    : Pallete
                                                                        .blueColor,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                20.sbH,
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Matric Number: ',
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: user.matricNo
                                                                  .isEmpty
                                                              ? '-------'
                                                              : user.matricNo,
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                20.sbH,
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Phone Number: ',
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: user.banner,
                                                          style: TextStyle(
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString()),
                                          loading: () => const Loader(),
                                        ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
