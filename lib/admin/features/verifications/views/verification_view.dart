import 'package:bu_news/admin/features/approval/widgets/applications_tile.dart';
import 'package:bu_news/admin/features/verifications/controller/verification_controller.dart';
import 'package:bu_news/admin/features/verifications/widgets/verification_tile.dart';
import 'package:bu_news/features/profile/widgets/profile_tile.dart';
import 'package:bu_news/models/verification_model.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class VerificationsView extends ConsumerStatefulWidget {
  const VerificationsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationsViewState();
}

class _VerificationsViewState extends ConsumerState<VerificationsView> {
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final PageController _controller = PageController();
  final ValueNotifier<int> isPendingSelected = ValueNotifier(0);
  final ValueNotifier<int> isApprovedSelected = ValueNotifier(0);
  final ValueNotifier<int> isRejectedSelected = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    selectedIndex.value = 0;
  }

  void showReasonDialog(WidgetRef ref, BuildContext context,
      VerificationModel verification) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Reason'),
            actions: [
              TextButton(
                onPressed: () {
                  reject(verification, 'unclear image');
                  Routemaster.of(context).pop();
                },
                child: const Text(
                  'Unclear image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  reject(verification, 'inconsistent information');
                  Routemaster.of(context).pop();
                },
                child: const Text(
                  'Inconsistent info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void approve(VerificationModel verification) {
    ref
        .read(verificationControllerProvider.notifier)
        .approveApplication(context, verification);
  }

  void reject(VerificationModel verification, String reason) {
    ref
        .read(verificationControllerProvider.notifier)
        .rejectApplication(context, verification, reason);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(verificationControllerProvider);

    return SizedBox(
      child: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: selectedIndex,
              child: const SizedBox.shrink(),
              builder: (context, value, child) {
                return SizedBox(
                  width: 400.w,
                  child: Column(
                    children: [
                      200.sbH,
                      //! pending
                      AnimatedScale(
                        duration: const Duration(milliseconds: 90),
                        scale: selectedIndex.value == 0 ? 1.1 : 1,
                        child: ProfileTile(
                          onTap: () {
                            selectedIndex.value = 0;
                            _controller.animateToPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              0,
                            );
                          },
                          onHover: (value) {
                            selectedIndex.value = 0;
                          },
                          icon: PhosphorIcons.warning,
                          isSwitch: false,
                          title: 'Pending',
                          isLogout: false,
                          iconColor: Colors.yellow,
                        ),
                      ),
                      100.sbH,

                      //! approved
                      AnimatedScale(
                        duration: const Duration(milliseconds: 90),
                        scale: selectedIndex.value == 1 ? 1.1 : 1,
                        child: ProfileTile(
                          onTap: () {
                            selectedIndex.value = 1;
                            _controller.animateToPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              1,
                            );
                          },
                          onHover: (value) {
                            selectedIndex.value = 1;
                          },
                          icon: PhosphorIcons.checks,
                          isSwitch: false,
                          title: 'Approved',
                          isLogout: false,
                          iconColor: Colors.green,
                        ),
                      ),
                      100.sbH,

                      //! rejected
                      AnimatedScale(
                        duration: const Duration(milliseconds: 90),
                        scale: selectedIndex.value == 2 ? 1.1 : 1,
                        child: ProfileTile(
                          onTap: () {
                            selectedIndex.value = 2;
                            _controller.animateToPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              2,
                            );
                          },
                          onHover: (value) {
                            selectedIndex.value = 2;
                          },
                          icon: PhosphorIcons.x,
                          isSwitch: false,
                          title: 'Rejected',
                          isLogout: false,
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          //! page view
          Expanded(
            child: PageView(
              controller: _controller,
              pageSnapping: true,
              onPageChanged: (value) {
                selectedIndex.value = value;
              },
              children: [
                //! pending
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: currentTheme.textTheme.bodyMedium!.color!
                            .withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      30.sbH,
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Pending Verification Applications',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      10.sbH,
                      ref.watch(getPendingVerificationsProvider).when(
                            data: (verifications) {
                              return Expanded(
                                flex: 8,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: verifications.length,
                                  itemBuilder: (context, index) {
                                    final verification = verifications[index];
                                    return ValueListenableBuilder(
                                        valueListenable: isPendingSelected,
                                        child: const SizedBox.shrink(),
                                        builder: (context, value, child) {
                                          return VerificationsTile(
                                            icon: isPendingSelected.value ==
                                                    index + 1
                                                ? Icon(
                                                    Icons.keyboard_arrow_up,
                                                    size: 25.sp,
                                                  )
                                                : Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25.sp,
                                                  ),
                                            onTap: () {
                                              if (isPendingSelected.value ==
                                                  0) {
                                                isPendingSelected.value =
                                                    index + 1;
                                              } else {
                                                isPendingSelected.value = 0;
                                              }
                                            },
                                            application: verification,
                                            delay: index + 0.2,
                                            height: isPendingSelected.value ==
                                                    index + 1
                                                ? 650.h
                                                : 100.h,
                                            isExtended: false,
                                            isLoading: isLoading,
                                            status:
                                                verification.verificationStatus,
                                            approve: () =>
                                                approve(verification),
                                            reject: () => showReasonDialog(
                                                ref, context, verification),
                                          );
                                        });
                                  },
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              if (kDebugMode) print(error);
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),

                //! approved
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: currentTheme.textTheme.bodyMedium!.color!
                          .withOpacity(0.4),
                      width: 0.5,
                    ),
                  )),
                  child: Column(
                    children: [
                      30.sbH,
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Approved Verification Applications',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      10.sbH,
                      ref.watch(getApprovedVerificationsProvider).when(
                            data: (applications) {
                              return Expanded(
                                flex: 8,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: applications.length,
                                  itemBuilder: (context, index) {
                                    final application = applications[index];
                                    return ValueListenableBuilder(
                                        valueListenable: isApprovedSelected,
                                        builder: (context, value, child) {
                                          return VerificationsTile(
                                            icon: isApprovedSelected.value ==
                                                    index + 1
                                                ? Icon(
                                                    Icons.keyboard_arrow_up,
                                                    size: 25.sp,
                                                  )
                                                : Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25.sp,
                                                  ),
                                            onTap: () {
                                              if (isApprovedSelected.value ==
                                                  0) {
                                                isApprovedSelected.value =
                                                    index + 1;
                                              } else {
                                                isApprovedSelected.value = 0;
                                              }
                                            },
                                            application: application,
                                            delay: index + 0.2,
                                            height: isApprovedSelected.value ==
                                                    index + 1
                                                ? 650.h
                                                : 100.h,
                                            isExtended: false,
                                            isLoading: isLoading,
                                            status:
                                                application.verificationStatus,
                                          );
                                        });
                                  },
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              if (kDebugMode) print(error);
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),
                //! rejected
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: currentTheme.textTheme.bodyMedium!.color!
                          .withOpacity(0.4),
                      width: 0.5,
                    ),
                  )),
                  child: Column(
                    children: [
                      30.sbH,
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Rejected Verification Applications',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      10.sbH,
                      ref.watch(getRejectedVerificationsProvider).when(
                            data: (applications) {
                              return Expanded(
                                flex: 8,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: applications.length,
                                  itemBuilder: (context, index) {
                                    final application = applications[index];
                                    return ValueListenableBuilder(
                                        valueListenable: isRejectedSelected,
                                        child: const SizedBox.shrink(),
                                        builder: (context, value, child) {
                                          return VerificationsTile(
                                            icon: isRejectedSelected.value ==
                                                    index + 1
                                                ? Icon(
                                                    Icons.keyboard_arrow_up,
                                                    size: 25.sp,
                                                  )
                                                : Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25.sp,
                                                  ),
                                            onTap: () {
                                              if (isRejectedSelected.value ==
                                                  0) {
                                                isRejectedSelected.value =
                                                    index + 1;
                                              } else {
                                                isRejectedSelected.value = 0;
                                              }
                                            },
                                            application: application,
                                            delay: index + 0.2,
                                            height: isRejectedSelected.value ==
                                                    index + 1
                                                ? 650.h
                                                : 100.h,
                                            isExtended: false,
                                            isLoading: isLoading,
                                            status:
                                                application.verificationStatus,
                                          );
                                        });
                                  },
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              if (kDebugMode) print(error);
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
