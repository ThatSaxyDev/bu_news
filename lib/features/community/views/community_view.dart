import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/community/views/search_communities_delegate.dart';
import 'package:bu_news/features/community/widgets/cannot_create_community_popup.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/button.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  final ValueNotifier<bool> isYoursSelected = ValueNotifier(false);
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/com/$communityName');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.all(11.w),
        child: FloatingActionButton(
          onPressed: () {
            if (user.isALead == false) {
              showGeneralDialog(
                  context: context,
                  //!SHADOW EFFECT
                  barrierColor: Pallete.blackColor.withOpacity(0.2),
                  transitionBuilder: (context, a1, a2, widget) =>
                      CannotCreateCommunityPopUp(
                        a1: a1,
                        a2: a2,
                      ),

                  //! ANIMATION DURATION
                  transitionDuration: const Duration(milliseconds: 200),

                  //! STILL DON'T KNOW WHAT THIS DOES, BUT IT'S REQUIRED
                  pageBuilder: (context, animation1, animation2) =>
                      const Text(""));
            }
          },
          backgroundColor: currentTheme.textTheme.bodyMedium!.color,
          child: const Icon(PhosphorIcons.plusBold),
        ),
      ),
      body: Column(
        children: [
          60.sbH,
          AppFadeAnimation(
            delay: 1,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 20.h),
              child: ValueListenableBuilder(
                  valueListenable: isYoursSelected,
                  child: const SizedBox.shrink(),
                  builder: (context, value, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            isYoursSelected.value = false;
                            _controller.animateToPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              0,
                            );
                          },
                          child: Text(
                            'Communities',
                            style: TextStyle(
                              color: isYoursSelected.value == true
                                  ? Pallete.greyColor
                                  : currentTheme.textTheme.bodyMedium!.color,
                              fontSize:
                                  isYoursSelected.value == true ? 20.sp : 27.sp,
                              fontWeight: isYoursSelected.value == true
                                  ? FontWeight.w400
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        40.sbW,
                        InkWell(
                          onTap: () {
                            isYoursSelected.value = true;
                            _controller.animateToPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              1,
                            );
                          },
                          child: Text(
                            'Yours',
                            style: TextStyle(
                              color: isYoursSelected.value == true
                                  ? currentTheme.textTheme.bodyMedium!.color
                                  : Pallete.greyColor,
                              fontSize:
                                  isYoursSelected.value == true ? 27.sp : 20.sp,
                              fontWeight: isYoursSelected.value == true
                                  ? FontWeight.w800
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: SearchCommunityDelegate(ref));
                          },
                          child: Icon(
                            PhosphorIcons.magnifyingGlass,
                            size: 25.sp,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),

          //!
          Expanded(
              child: PageView(
            onPageChanged: (value) {
              if (value == 0) {
                isYoursSelected.value = false;
              } else {
                isYoursSelected.value = true;
              }
            },
            controller: _controller,
            pageSnapping: true,
            children: [
              // general communities
              ref.watch(userCommunitiesProvider).when(
                    data: (communities) => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('bu/${community.name}'),
                          onTap: () {
                            navigateToCommunity(context, community.name);
                          },
                        );
                      },
                    ),
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),

              //! yours
              ref.watch(userOwnCommunitiesProvider).when(
                    data: (communities) => communities.isEmpty
                        ? Center(
                            child: ref.watch(getApprovalsProvider).when(
                                  data: (applications) {
                                    int applicationsNumber =
                                        applications.length;
                                    if (applications.isNotEmpty) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'You have ',
                                                  style: TextStyle(
                                                    color: currentTheme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: applicationsNumber
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 21.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Pallete.blueColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: applicationsNumber == 1
                                                      ? ' application pending'
                                                      : ' applications pending',
                                                  style: TextStyle(
                                                    color: currentTheme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          20.sbH,
                                          BButton(
                                            onTap: () {
                                              if (user.isALead == false) {
                                                showGeneralDialog(
                                                    context: context,
                                                    //!SHADOW EFFECT
                                                    barrierColor: Pallete
                                                        .blackColor
                                                        .withOpacity(0.2),
                                                    transitionBuilder: (context,
                                                            a1, a2, widget) =>
                                                        CannotCreateCommunityPopUp(
                                                          a1: a1,
                                                          a2: a2,
                                                        ),

                                                    //! ANIMATION DURATION
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),

                                                    //! STILL DON'T KNOW WHAT THIS DOES, BUT IT'S REQUIRED
                                                    pageBuilder: (context,
                                                            animation1,
                                                            animation2) =>
                                                        const Text(""));
                                              }
                                            },
                                            width: 200.h,
                                            text: 'Create A Community',
                                          ),
                                        ],
                                      );
                                    }
                                    return BButton(
                                      onTap: () {
                                        if (user.isALead == false) {
                                          showGeneralDialog(
                                              context: context,
                                              //!SHADOW EFFECT
                                              barrierColor: Pallete.blackColor
                                                  .withOpacity(0.2),
                                              transitionBuilder: (context, a1,
                                                      a2, widget) =>
                                                  CannotCreateCommunityPopUp(
                                                    a1: a1,
                                                    a2: a2,
                                                  ),

                                              //! ANIMATION DURATION
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 200),

                                              //! STILL DON'T KNOW WHAT THIS DOES, BUT IT'S REQUIRED
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  const Text(""));
                                        }
                                      },
                                      width: 200.h,
                                      text: 'Create A Community',
                                    );
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader(),
                                ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: communities.length,
                            itemBuilder: (context, index) {
                              final community = communities[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(community.avatar),
                                ),
                                title: Text('bu/${community.name}'),
                                onTap: () {
                                  navigateToCommunity(context, community.name);
                                },
                              );
                            },
                          ),
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ],
          )),
        ],
      ),
    );
  }
}
