// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/features/profile/controllers/profile_controller.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final double delay;
  const PostCard({
    super.key,
    required this.post,
    required this.delay,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure you want to delete this post'),
            actions: [
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                  ref
                      .read(postControllerProvider.notifier)
                      .deletePost(post, context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ref
                        .watch(themeNotifierProvider)
                        .textTheme
                        .bodyMedium!
                        .color!,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ref
                        .watch(themeNotifierProvider)
                        .textTheme
                        .bodyMedium!
                        .color!,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/kom/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void bookmark(BuildContext context, WidgetRef ref, String uid) async {
    if (post.bookmarkedBy.contains(uid)) {
      ref
          .read(postControllerProvider.notifier)
          .removeFromBookmarks(post.id, context);
    } else {
      ref
          .read(postControllerProvider.notifier)
          .addToBookmarks(post.id, context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    // final isLoading = ref.watch(postControllerProvider);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // onTap: () => navigateToComments(context),
      child: AppFadeAnimation(
        delay: delay,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
              border: Border.all(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
              boxShadow: [
                BoxShadow(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                    offset: const Offset(5, 5)),
              ],
              borderRadius: BorderRadius.circular(5.r)),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 16.w,
                      ).copyWith(right: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          post.communityProfilePic),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.communityName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        2.sbH,
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            '@${post.username}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // const Spacer(),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    PhosphorIcons.trash,
                                    color: Pallete.thickRed,
                                  ),
                                ),
                            ],
                          ),
                          6.sbH,
                          Divider(
                            color: currentTheme.textTheme.bodyMedium!.color!,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.h, bottom: 15.h),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    post.link!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                            ),
                          if (isTypeLink)
                            Container(
                              height: 150.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Text(
                                    post.description!,
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color!,
                                    ),
                                  ),
                                ),
                                post.link!.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          20.sbH,
                                          Container(
                                            height: 80.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: AnyLinkPreview(
                                              displayDirection: UIDirection
                                                  .uiDirectionHorizontal,
                                              link: post.link!,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          5.sbH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      PhosphorIcons.heartBold,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    // '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    '1',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     PhosphorIcons.arrowFatDownBold,
                                  //     color: post.downvotes.contains(user.uid)
                                  //         ? Pallete.thickRed
                                  //         : null,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      PhosphorIcons.chatCircleDotsBold,
                                    ),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? '' : post.commentCount}',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () =>
                                    bookmark(context, ref, user.uid),
                                icon: post.bookmarkedBy.contains(user.uid)
                                    ? Icon(
                                        PhosphorIcons.bookmarkFill,
                                        color: Pallete.blueColor,
                                      )
                                    : Icon(
                                        PhosphorIcons.bookmarkBold,
                                        color: currentTheme
                                            .textTheme.bodyMedium!.color!,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
