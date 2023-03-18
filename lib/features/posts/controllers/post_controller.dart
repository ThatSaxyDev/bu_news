import 'dart:io';

import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/posts/repositories/post_repository.dart';
import 'package:bu_news/features/profile/controllers/profile_controller.dart';
import 'package:bu_news/models/comment_model.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchUserPosts(communities);
});

final userBookmarksProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchUserBookMarks();
});

final guestPostProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchGuestPosts();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.getCommentsOfPost(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PostController({
    required PostRepository postRepository,
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
    required File? image,
    Uint8List? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    String photo = '';
    if (image != null) {
      final res = await _storageRepository.storeFile(
        path: 'posts/ids',
        id: user.uid,
        file: image,
        webFile: file,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => photo = r,
      );
    }

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
      imageUrl: photo,
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

  void addToBookmarks(
    String postId,
    BuildContext context,
  ) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    final res = await _postRepository.addToBookmarks(postId, uid);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Added to bookmarks!');
      },
    );
  }

  void removeFromBookmarks(
    String postId,
    BuildContext context,
  ) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    final res = await _postRepository.removeFromBookmarks(postId, uid);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Removed from bookmarks!');
      },
    );
  }

  Stream<List<Post>> fetchUserBookMarks() {
    final uid = _ref.read(userProvider)!.uid;
    return _postRepository.fetchUserBookMarks(uid);
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);

    res.fold(
      (l) => null,
      (r) => showSnackBar(context, 'Deleted!'),
    );
  }

  void like(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.like(post, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
    );
    final res = await _postRepository.addComment(comment);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }

  // void awardPost({
  //   required Post post,
  //   required String award,
  //   required BuildContext context,
  // }) async {
  //   final user = _ref.read(userProvider)!;

  //   final res = await _postRepository.awardPost(post, award, user.uid);

  //   res.fold(
  //     (l) => showSnackBar(context, l.message),
  //     (r) {
  //       _ref
  //           .read(userProfileControllerProvider.notifier)
  //           .updateUserKoinz(UserKarma.awardPost);
  //       _ref.read(userProvider.notifier).update((state) {
  //         state?.awards.remove(award);
  //         return state;
  //       });
  //       Routemaster.of(context).pop();
  //     },
  //   );
  // }
}
