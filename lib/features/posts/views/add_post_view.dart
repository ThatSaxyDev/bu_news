import 'dart:io';

import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/utils.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class AddPostView extends ConsumerStatefulWidget {
  final String? type;
  const AddPostView({
    super.key,
    this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostViewState();
}

class _AddPostViewState extends ConsumerState<AddPostView> {
  final titleController = TextEditingController();
  final textPostController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  File? image;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textPostController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        image != null &&
        titleController.text.isNotEmpty) {
      // ref.read(adminPostControllerProvider.notifier).shareImagePost(
      //       context: context,
      //       title: titleController.text.trim(),
      //       selectedCommunity: selectedCommunity ?? communities[0],
      //       file: bannerFile,
      //     );
    } else if (widget.type == 'text' &&
        titleController.text.isNotEmpty &&
        textPostController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: textPostController.text.trim(),
            link: linkController.text.isEmpty ? '' : linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isTypeImage = widget.type == 'image';
    // final isTypeLink = widget.type == 'link';
    final isTypeText = widget.type == 'text';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      body: Column(
        children: [
          71.sbH,
          AppFadeAnimation(
            delay: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Routemaster.of(context).replace('/base-nav-wrapper');
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20.sbH,
                      //! header
                      Text(
                        'Post ${widget.type}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      8.sbH,
                      Text(
                        '',
                        style: TextStyle(
                          color: Pallete.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  40.sbW,
                ],
              ),
            ),
          ),

          //!
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 14.sp),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.all(18.w)),
                    maxLength: 30,
                  ),
                  20.sbH,
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(15.r),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: image != null
                              ? Image.file(image!)
                              : Center(
                                  child: Icon(
                                    PhosphorIcons.image,
                                    size: 40.h,
                                  ),
                                ),
                        ),
                      ),
                    ),

                  if (isTypeText)
                    Column(
                      children: [
                        TextField(
                          controller: textPostController,
                          decoration: InputDecoration(
                              hintText: 'Type something...',
                              hintStyle: TextStyle(fontSize: 14.sp),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.all(18.w)),
                          // maxLength: 21,
                          maxLines: 7,
                        ),

                        40.sbH,

                        // link
                        TextField(
                          controller: linkController,
                          decoration: InputDecoration(
                              hintText: 'Link',
                              hintStyle: TextStyle(fontSize: 14.sp),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.all(18.w)),
                          // maxLength: 30,
                          maxLines: 3,
                        ),
                      ],
                    ),

                  // if (isTypeLink)
                  //   TextField(
                  //     controller: linktController,
                  //     decoration: InputDecoration(
                  //         hintText: 'Link',
                  //         hintStyle: TextStyle(fontSize: 14.sp),
                  //         filled: true,
                  //         border: OutlineInputBorder(
                  //           borderSide: const BorderSide(color: Colors.transparent),
                  //           borderRadius: BorderRadius.circular(10.r),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: const BorderSide(color: Colors.transparent),
                  //           borderRadius: BorderRadius.circular(10.r),
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: const BorderSide(color: Colors.transparent),
                  //           borderRadius: BorderRadius.circular(10.r),
                  //         ),
                  //         contentPadding: EdgeInsets.all(18.w)),
                  //     // maxLength: 30,
                  //     maxLines: 3,
                  //   ),

                  30.sbH,
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select community'),
                  ),
                  ref.watch(userOwnCommunitiesProvider).when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) {
                            return const SizedBox();
                          }

                          return DropdownButton(
                            dropdownColor: currentTheme.backgroundColor,
                            style: TextStyle(
                                color:
                                    currentTheme.textTheme.bodyMedium!.color),
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                  100.sbH,
                  isLoading
                      ? const Loader()
                      : BButton(
                          height: 60.h,
                          width: double.infinity,
                          radius: 10.r,
                          onTap: sharePost,
                          color: Pallete.blueColor,
                          text: 'Share',
                        ),
                  // Spc(h: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
