import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/features/posts/widgets/post_card.dart';
import 'package:bu_news/features/profile/widgets/approval_tile.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class AppprovalStatusView extends ConsumerStatefulWidget {
  const AppprovalStatusView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppprovalStatusViewState();
}

class _AppprovalStatusViewState extends ConsumerState<AppprovalStatusView>
    with TickerProviderStateMixin {
  //
  late TabController tabBarController;

  //!
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
  }

  //!
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.h,
          centerTitle: true,
          leadingWidth: 50.w,
          leading: InkWell(
            onTap: () {
              Routemaster.of(context).replace('/base-nav-wrapper');
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'Community Approval',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: currentTheme.textTheme.bodyMedium!.color,
            indicatorWeight: 4,
            labelColor: currentTheme.textTheme.bodyMedium!.color,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Approved',
              ),
              Tab(
                text: 'Rejected',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: [
            //! pending
            ref.watch(getPending).when(
                  data: (applications) {
                    if (applications.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          final application = applications[index];
                          return ApprovalTile(
                            name: application.communityName,
                            description: application.description,
                            date: application.createdAt,
                            status: application.approvalStatus,
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        'You have nothing pending',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    if (kDebugMode) print(error);
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                ),

            //! approved
            ref.watch(getApproved).when(
                  data: (applications) {
                    if (applications.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          final application = applications[index];
                          return Text(applications.length.toString());
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        'You have nothing approved',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    if (kDebugMode) print(error);
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                ),

            //! rejected
            ref.watch(getRejected).when(
                  data: (applications) {
                    if (applications.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          final application = applications[index];
                          return Text(applications.length.toString());
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        'You have nothing rejected',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
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
    );
  }
}
