// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/posts/widgets/post_card.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/string_extensions.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CommnunityProfileView extends ConsumerWidget {
  final String name;
  const CommnunityProfileView({
    super.key,
    required this.name,
  });

  void navigateToCommunitySettings(BuildContext context) {
    Routemaster.of(context).push('/com/$name/community-settings/$name');
  }

  void navigateToType(BuildContext context) {
    Routemaster.of(context).push('/add-post/$name');
  }

  void joinCommunity(
    WidgetRef ref,
    Community community,
    BuildContext context,
  ) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    String member;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              if (community.members.length == 1) {
                member = 'member';
              } else {
                member = 'members';
              }
              return NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      expandedHeight: 150.h,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: community.banner,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black12.withOpacity(0.1),
                                      Colors.black12.withOpacity(0.1),
                                      Colors.black26,
                                      Colors.black26,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  // borderRadius: BorderRadius.circular(15.r),
                                ),
                              )
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                  .shimmer(duration: 1200.ms),
                              errorWidget: (context, url, error) => Container(

                                color: Pallete.greey,
                                height: 300.h,
                                width: 250.w,
                                child: Image.asset('main_logo'.png),
                              ),
                            ),
                            // child: Image.network(
                            //   community.banner,
                            //   fit: BoxFit.cover,
                            // ),
                          )
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(16.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 33.w,
                              ),
                            ),
                            15.sbH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'bu/${community.name}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user.uid)
                                    ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.w)),
                                        onPressed: () =>
                                            navigateToCommunitySettings(
                                                context),
                                        child: const Text('Settings',
                                            style: TextStyle(
                                                color: Pallete.blueColor)),
                                      )
                                    : community.name == 'busa_official'
                                        ? const SizedBox.shrink()
                                        : OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25.w)),
                                            onPressed: () => joinCommunity(
                                                ref, community, context),
                                            child: Text(community.members
                                                    .contains(user.uid)
                                                ? 'Joined'
                                                : 'Join'),
                                          ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child:
                                  Text('${community.members.length} $member'),
                            ),
                            10.sbH,
                            const Divider(thickness: 2),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: ref.watch(getCommunityPostsProvider(name)).when(
                      data: (data) {
                        if (!community.members.contains(user.uid)) {
                          return Center(
                            child: Text(
                              'You are not a member of this community',
                              style: TextStyle(
                                color: currentTheme.textTheme.bodyMedium!.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.sp,
                              ),
                            ),
                          );
                        }
                        if (data.isEmpty) {
                          return Center(
                            child: Text(
                              'There are no posts here yet',
                              style: TextStyle(
                                color: currentTheme.textTheme.bodyMedium!.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.sp,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final post = data[index];
                            return PostCard(
                              post: post,
                              delay: index + 0.2,
                              isInCommentView: true,
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
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
      floatingActionButton: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              if (!community.mods.contains(user.uid)) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.all(11.w),
                child: FloatingActionButton(
                  onPressed: () => navigateToType(context),
                  backgroundColor: currentTheme.textTheme.bodyMedium!.color,
                  child: const Icon(PhosphorIcons.pen),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const SizedBox.shrink(),
          ),
    );
  }
}
