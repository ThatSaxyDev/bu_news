import 'dart:io';

import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/constants.dart';
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

class EditCommunityView extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityView({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityViewState();
}

class _EditCommunityViewState extends ConsumerState<EditCommunityView> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          profileFile: profileFile,
          community: community,
          bannerFile: bannerFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Edit Community',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  20.sbH,
                  SizedBox(
                    height: 185.h,
                    child: Stack(
                      children: [
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
                              height: 150.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: bannerWebFile != null
                                  ? Image.memory(bannerWebFile!)
                                  : bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : community.banner.isEmpty ||
                                              community.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(community.banner),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 15.w,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileWebFile != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(profileWebFile!),
                                    radius: 32,
                                  )
                                : profileFile != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            FileImage(profileFile!),
                                        radius: 32,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(community.avatar),
                                        radius: 32,
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  isLoading
                      ? const Loader()
                      : BButton(
                          height: 60.h,
                          width: double.infinity,
                          radius: 10.r,
                          onTap: () => save(community),
                          color: Pallete.greyColor,
                          text: 'Save',
                        ),
                  60.sbH,
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
