import 'package:bu_news/features/posts/controllers/post_controller.dart';
import 'package:bu_news/features/posts/widgets/comment_card.dart';
import 'package:bu_news/features/posts/widgets/post_card.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:bu_news/utils/text_input.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommentsView extends ConsumerStatefulWidget {
  final Post post;
  const CommentsView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsViewState();
}

class _CommentsViewState extends ConsumerState<CommentsView> {
  final TextEditingController commentController = TextEditingController();

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Post',
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: currentTheme.textTheme.bodyMedium!.color),
        ),
      ),
      body: ref.watch(getPostByIdProvider(widget.post.id)).when(
            data: (post) {
              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    10.sbH,
                    PostCard(
                      isInCommentView: false,
                      post: widget.post,
                      delay: 1.2,
                    ),
                    20.sbH,
                    TextInputBox(
                      height: 50.h,
                      hintText: 'Comment..',
                      controller: commentController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (val) => addComment(post),
                    ),
                    20.sbH,
                    ref.watch(getPostCommentsProvider(widget.post.id)).when(
                          data: (data) {
                            if (data.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 70.h),
                                child: const Text(
                                  'No comments here yet, be the first to comment!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                              );
                            }
                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 70.h),
                              child: Column(
                                children: data
                                    .map((e) => CommentCard(comment: e))
                                    .toList(),
                              ),
                            );
                            // return ListView.builder(
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   // physics: const AlwaysScrollableScrollPhysics(
                            //   //     parent: BouncingScrollPhysics()),
                            //   itemCount: data.length,
                            //   itemBuilder: (context, index) {
                            //     final comment = data[index];
                            //     return CommentCard(comment: comment);
                            //   },
                            // );
                          },
                          error: (error, stackTrace) {
                            if (kDebugMode) print(error);
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              if (kDebugMode) print(error);
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),

      //! input
    );
  }
}
