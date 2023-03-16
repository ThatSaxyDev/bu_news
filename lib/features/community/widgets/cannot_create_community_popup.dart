// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/views/community_apllication_view.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CannotCreateCommunityPopUp extends ConsumerWidget {
  final Animation<double> a1;
  final Animation<double> a2;
  const CannotCreateCommunityPopUp({
    super.key,
    required this.a1,
    required this.a2,
  });

  void navigateToCommunityApplication(BuildContext context) {
    Routemaster.of(context).push('/community-application');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Dialog(
      elevation: 65.0.h,
      backgroundColor: Colors.transparent,
      child: Container(
        //! USE ANIMATION DOUBLE VALUES TO ANIMATE DIALOGUE
        height: 200.h * a1.value,
        width: 280.w * a2.value,
        padding: EdgeInsets.all(25.w),
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(PhosphorIcons.xBold),
                ),
              ),
              12.sbH,
              Text(
                'You do not have approval to create communities',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              25.sbH,
              BButton(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => const CommunityApplicationView(),));
                },
                width: 150.h,
                text: 'Apply',
              ),
            ],
          ),
        ),
      ),
    );
  }
}