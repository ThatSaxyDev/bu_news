import 'package:bu_news/admin/features/communities/controllers/community_controller.dart';
import 'package:bu_news/responsive/responsive.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateCommunityView extends ConsumerStatefulWidget {
  const CreateCommunityView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityViewState();
}

class _CreateCommunityViewState extends ConsumerState<CreateCommunityView> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(adminCommunityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(adminCommunityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create A community',
        ),
      ),
      body: Responsive(
        child: SizedBox(
          child: isLoading
              ? const Loader()
              : Column(
                  children: [
                    20.sbH,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Community Name',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                    15.sbH,
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(' '))
                      ],
                      controller: communityNameController,
                      onChanged: (value) {
                        communityNameController.value = TextEditingValue(
                            text: value.toLowerCase(),
                            selection: communityNameController.selection);
                      },
                      decoration: InputDecoration(
                          prefixText: 'com/',
                          hintText: 'community_name',
                          hintStyle: TextStyle(fontSize: 13.sp),
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
                      maxLength: 21,
                    ),
                    const Spacer(),
                    BButton(
                      height: 50.h,
                      width: double.infinity,
                      radius: 10.r,
                      onTap: createCommunity,
                      color: Pallete.greyColor,
                      text: 'Create Community',
                    ),
                    50.sbH,
                  ],
                ),
        ),
      ),
    );
  }
}
