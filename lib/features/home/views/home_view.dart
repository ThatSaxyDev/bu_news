import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/home/widgets/circular_fab.dart';
import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/features/posts/widgets/post_card.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  //!
  void navigateToType(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.h,
          centerTitle: true,
          leadingWidth: 50.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 7.w),
            child: CircleAvatar(
              backgroundColor: Pallete.greyColor,
              backgroundImage: NetworkImage(user.profilePic),
            ),
          ),
          title: Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: AssetImage('BUewsicon-blue'.png),
                fit: BoxFit.cover,
              ),
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
                text: 'From BUSA',
              ),
              Tab(
                text: 'For You',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: [
            //! from busa
            ref.watch(getCommunityPostsProvider('busa_official')).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          'There are no posts here yet',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                     padding: EdgeInsets.only(bottom: 60.h),
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data[index];
                        return PostCard(
                          isInCommentView: true,
                          post: post,
                          delay: index + 0.2,
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    if (kDebugMode) print(error);
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                ),

            //! all
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) =>
                      ref.watch(userPostProvider(communities)).when(
                            data: (data) {
                              if (data.isEmpty) {
                                return Center(
                                  child: Text(
                                    'There are no posts here yet',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                itemCount: data.length,
                                padding: EdgeInsets.only(bottom: 60.h),
                                itemBuilder: (context, index) {
                                  final post = data[index];
                                  return PostCard(
                                    isInCommentView: true,
                                    post: post,
                                    delay: index + 0.2,
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              if (kDebugMode) print(error);
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
          ],
        ),
        floatingActionButton: ref.watch(getApproved).when(
              data: (applications) {
                if (applications.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.all(11.w),
                  child: FloatingActionButton(
                    onPressed: () => navigateToType(context),
                    backgroundColor: currentTheme.textTheme.bodyMedium!.color,
                    child: const Icon(PhosphorIcons.plusBold),
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const SizedBox.shrink(),
            ),
      ),
    );
  }
}
