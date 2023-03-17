import 'dart:io';

import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/enums/enums.dart';
import '../repository/profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // void addToCanInteract(
  //     {required BuildContext context, required String uidToAdd}) async {
  //   state = true;
  //   UserModel user = _ref.read(userProvider)!;
  //   final res = await _userProfileRepository.addToCanInteract(user, uidToAdd);
  //   res.fold(
  //     (l) => showSnackBar(context, l.message),
  //     (r) => showSnackBar(context, 'Done'),
  //   );
  // }

  void editUserProfile(
      {required BuildContext context,
      required File? profileFile,
      required File? bannerFile,
      required String name,
      Uint8List? file}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: file,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
        webFile: file,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Done!');
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  void addToBookmarks({
    required BuildContext context,
    required String postId,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    final res = await _userProfileRepository.addToBookmarks(user.uid, postId);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Added to bookmarks!');
        // _ref.read(userProvider.notifier).update((state) => user);
        // Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  // void followUserProfile(UserModel userToFollow, BuildContext context) async {
  //   final user = _ref.read(userProvider)!;

  //   Either<Failure, void> res;

  //   if (userToFollow.followers.contains(user.uid)) {
  //     await _userProfileRepository.removeFromUserFollowing(
  //         userToFollow.uid, user.uid);
  //     res = await _userProfileRepository.unfollowUserProfile(
  //         userToFollow.uid, user.uid);
  //   } else {
  //     await _userProfileRepository.addToUserFollowing(
  //         userToFollow.uid, user.uid);
  //     res = await _userProfileRepository.followUserProfile(
  //         userToFollow.uid, user.uid);
  //   }

  //   res.fold(
  //     (failure) => showSnackBar(context, failure.message),
  //     (success) {
  //       if (userToFollow.followers.contains(user.uid)) {
  //         showSnackBar(context, 'Unfollowed');
  //       } else {
  //         showSnackBar(context, 'Followed');
  //       }
  //     },
  //   );
  // }
}
