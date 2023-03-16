import 'dart:io';

import 'package:bu_news/core/utils.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/text_input.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommunityApplicationView extends ConsumerStatefulWidget {
  const CommunityApplicationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityApplicationViewState();
}

class _CommunityApplicationViewState
    extends ConsumerState<CommunityApplicationView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? idCardPhoto;

  @override
  void dispose() {
    _nameController.dispose();
    _matricController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void selectIdImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        idCardPhoto = File(res.files.first.path!);
      });
    }
  }

  void apply() {
    ref.read(communityControllerProvider.notifier).applyToCreateCommunity(
          context: context,
          communityName: _nameController.text,
          matricNo: _matricController.text,
          photoIdCard: idCardPhoto,
          description: _descriptionController.text,
          approvalStatus: 'pending',
        );
  }

  //!
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Apply',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color,
            fontSize: 21.sp,
          ),
        ),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: 24.padH,
                child: Column(
                  children: [
                    20.sbH,
                    //! name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Name',
                          style: TextStyle(
                            fontSize: 14.6.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.sbH,
                        TextInputBox(
                          height: 56.h,
                          hintText: '',
                          controller: _nameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    20.sbH,

                    //! description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Description',
                          style: TextStyle(
                            fontSize: 14.6.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.sbH,
                        TextInputBox(
                          height: 56.h,
                          hintText: '',
                          controller: _descriptionController,
                          maxLines: 5,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    20.sbH,

                    //! matric
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Matric Number',
                          style: TextStyle(
                            fontSize: 14.6.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        10.sbH,
                        TextInputBox(
                          height: 56.h,
                          hintText: '',
                          controller: _matricController,
                          maxLines: 5,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    20.sbH,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Student ID Card',
                        style: TextStyle(
                          fontSize: 14.6.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    10.sbH,
                    GestureDetector(
                      onTap: selectIdImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(15.r),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: idCardPhoto != null
                              ? Image.file(idCardPhoto!)
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
                    BButton(
                      onTap: () {
                        if (idCardPhoto != null) {
                          apply();
                        }
                      },
                      height: 50.h,
                      width: 200.w,
                      text: 'Apply',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
