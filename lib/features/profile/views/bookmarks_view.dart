import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/features/posts/widgets/post_card.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/app_fade_animation.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Column(
        children: [
          71.sbH,
          AppFadeAnimation(
            delay: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Routemaster.of(context).replace('/base-nav-wrapper');
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20.sbH,
                      //! header
                      Text(
                        'Bookmarks',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      8.sbH,
                      Text(
                        '',
                        style: TextStyle(
                          color: Pallete.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  40.sbW,
                ],
              ),
            ),
          ),
          10.sbH,
          Expanded(
            child: ref.watch(userBookmarksProvider).when(
                  data: (bookmarks) {
                    if (bookmarks.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: bookmarks.length,
                        itemBuilder: (context, index) {
                          final post = bookmarks[index];
                          return PostCard(
                            isInCommentView: true,
                            post: post,
                            delay: index + 0.2,
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        'You have no bookmarks',
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
          )
        ],
      ),
    );
  }
}
