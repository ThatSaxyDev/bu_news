// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentTimeAgo =
        timeago.format(comment.createdAt, locale: 'en_short');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 4.h),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
                radius: 18.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${comment.username}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        comment.text,
                      )
                    ],
                  ),
                ),
              ),
              Text(commentTimeAgo),
            ],
          ),
          // TODO: a nested comment section later
        ],
      ),
    );
  }
}
