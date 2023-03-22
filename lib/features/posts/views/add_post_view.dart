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
import 'package:bu_news/utils/picker.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class AddPostView extends ConsumerStatefulWidget {
  final String isFromCommunity;
  const AddPostView({
    super.key,
    required this.isFromCommunity,
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
  int _selectedCommunityIndex = 0;

  File? image;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textPostController.dispose();
  }

  void selectImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (titleController.text.isNotEmpty && textPostController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: textPostController.text.trim(),
            link: linkController.text.isEmpty ? '' : linkController.text.trim(),
            image: image,
          );
    } else {
      showSnackBar(context, 'Please enter a title and some content');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

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
                      Routemaster.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20.sbH,
                      //! header
                      Text(
                        'Post',
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
                  1.sbW,
                ],
              ),
            ),
          ),

          //!
          Expanded(
            child: isLoading
                ? const Loader()
                : Container(
                    padding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          widget.isFromCommunity == 'from-home'
                              ? Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Select community: ',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    20.sbH,
                                    ref.watch(userOwnCommunitiesProvider).when(
                                          data: (communities) {
                                            if (communities.isEmpty) {
                                              return const SizedBox.shrink();
                                            }

                                            return InkWell(
                                              onTap: () => showPicker(
                                                context,
                                                CupertinoPicker(
                                                  scrollController:
                                                      FixedExtentScrollController(
                                                          initialItem:
                                                              _selectedCommunityIndex),
                                                  magnification: 1,
                                                  squeeze: 1.2,
                                                  useMagnifier: false,
                                                  itemExtent: 32,
                                                  onSelectedItemChanged:
                                                      (int selectedCommunity) {
                                                    setState(() {
                                                      _selectedCommunityIndex =
                                                          selectedCommunity;
                                                    });
                                                  },
                                                  children:
                                                      List<Widget>.generate(
                                                    communities.length,
                                                    (index) => Text(
                                                      communities[index].name,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7.w,
                                                    vertical: 10.h),
                                                decoration: BoxDecoration(
                                                  color: Pallete.blueColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                ),
                                                child: Center(
                                                  child: Wrap(
                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        communities[
                                                                _selectedCommunityIndex]
                                                            .name,
                                                        style: TextStyle(
                                                          color: Pallete
                                                              .whiteColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      10.sbW,
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color:
                                                            Pallete.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            // DropdownButton(
                                            //   dropdownColor:
                                            //       currentTheme.backgroundColor,
                                            //   style: TextStyle(
                                            //       color: currentTheme.textTheme
                                            //           .bodyMedium!.color),
                                            //   value:
                                            //       selectedCommunity ?? data[0],
                                            //   items: data
                                            //       .map(
                                            //         (e) => DropdownMenuItem(
                                            //           value: e,
                                            //           child: Text(e.name),
                                            //         ),
                                            //       )
                                            //       .toList(),
                                            //   onChanged: (val) {
                                            //     setState(() {
                                            //       selectedCommunity = val;
                                            //     });
                                            //   },
                                            // );
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString()),
                                          loading: () => const Loader(),
                                        ),
                                    30.sbH,
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Posting to:  ',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: Pallete.blueColor,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Text(
                                            widget.isFromCommunity,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    30.sbH,
                                  ],
                                ),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                hintStyle: TextStyle(fontSize: 14.sp),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                contentPadding: EdgeInsets.all(18.w)),
                            maxLength: 30,
                          ),
                          20.sbH,
                          Column(
                            children: [
                              TextField(
                                controller: textPostController,
                                decoration: InputDecoration(
                                    hintText: 'Type something...',
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    contentPadding: EdgeInsets.all(18.w)),
                                // maxLength: 21,
                                maxLines: 7,
                              ),

                              //! image
                              40.sbH,
                              GestureDetector(
                                onTap: selectImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(15.r),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color!,
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

                              40.sbH,

                              // link
                              TextField(
                                controller: linkController,
                                decoration: InputDecoration(
                                    hintText: 'Link',
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    contentPadding: EdgeInsets.all(18.w)),
                                // maxLength: 30,
                                maxLines: 3,
                              ),
                            ],
                          ),
                          100.sbH,
                          BButton(
                            height: 60.h,
                            width: double.infinity,
                            radius: 10.r,
                            onTap: sharePost,
                            color: Pallete.blueColor,
                            text: 'Share',
                          ),
                          60.sbH,
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
