import 'package:bu_news/admin/features/posts/repositories/admin_post_repository.dart';
import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils.dart';

final adminPostControllerProvider =
    StateNotifierProvider<AdminPostController, bool>((ref) {
  final postRepository = ref.watch(adminPostRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return AdminPostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class AdminPostController extends StateNotifier<bool> {
  final AdminPostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  AdminPostController({
    required AdminPostRepository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // to share text post
  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
      link: link,
      bookmarkedBy: [],
    );

    final res = await _postRepository.addPost(post);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted Successfully!');
        Routemaster.of(context).pop();
      },
    );
  }
}
