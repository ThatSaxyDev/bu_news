import 'dart:io';
import 'dart:typed_data';

import 'package:bu_news/admin/features/posts/controllers/admin_post_controller.dart';
import 'package:bu_news/core/utils.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../models/community_model.dart';

class AdminAddPostTypeView extends ConsumerStatefulWidget {
  const AdminAddPostTypeView({super.key, Z});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminAddPostTypeViewState();
}

class _AdminAddPostTypeViewState extends ConsumerState<AdminAddPostTypeView> {
  final titleController = TextEditingController();
  final textPostController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textPostController.dispose();
  }

  void selectImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          image = res.files.first.bytes;
        });
      }
    }
  }

  void sharePost() {
    if (titleController.text.isNotEmpty && textPostController.text.isNotEmpty) {
      ref.read(adminPostControllerProvider.notifier).shareTextPost(
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
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(adminPostControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentTheme.backgroundColor,
        title: Text(
          'Post',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: SizedBox(
        height: height(context),
        child: isLoading
            ? const Loader()
            : Padding(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
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
                        GestureDetector(
                          onTap: selectImage,
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
                                  ? Image.memory(image!)
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

                        30.sbH,
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Select comunity'),
                        ),
                        ref.watch(userCommunitiesProvider).when(
                              data: (data) {
                                communities = data;

                                if (data.isEmpty) {
                                  return const SizedBox();
                                }

                                return DropdownButton(
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
                        BButton(
                          height: 60.h,
                          width: double.infinity,
                          radius: 10.r,
                          onTap: sharePost,
                          color: Pallete.greyColor,
                          item: const Text('Share'),
                        ),
                        // Spc(h: 60.h),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
