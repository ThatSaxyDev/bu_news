import 'dart:io';

import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/repository/community_repository.dart';
import 'package:bu_news/models/application_model.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

import '../../../utils/snack_bar.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final userOwnCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserOwnCommunities();
});

final getApprovalsProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getApprovals();
});

final getPending = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getPendingApprovals();
});

final getApproved = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getApprovedApprovals();
});

final getRejected = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getrejectedApprovals();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // void createCommunity(String name, BuildContext context) async {
  //   state = true;
  //   final uid = _ref.read(userProvider)?.uid ?? '';
  //   Community community = Community(
  //     id: name,
  //     name: name,
  //     banner: Constants.bannerDefault,
  //     avatar: Constants.communityAvatarDefault,
  //     members: [uid],
  //     mods: [uid],
  //   );

  //   final res = await _communityRepository.createCommunity(community);
  //   state = false;
  //   res.fold(
  //     (failure) => showSnackBar(context, failure.message),
  //     (success) {
  //       showSnackBar(context, 'Komyuniti created successfully');
  //       Routemaster.of(context).pop();
  //     },
  //   );
  // }

  void applyToCreateCommunity({
    required BuildContext context,
    required String communityName,
    required String matricNo,
    required File? photoIdCard,
    required String description,
    required String approvalStatus,
  }) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    String image = '';

    if (photoIdCard != null) {
      final res = await _storageRepository.storeFile(
        path: 'appproval/ids',
        id: uid,
        file: photoIdCard,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => image = r,
      );
    }

    ApplicationModel application = ApplicationModel(
      userId: uid,
      communityName: communityName,
      matricNo: matricNo,
      photoIdCard: image,
      description: description,
      approvalStatus: approvalStatus,
      createdAt: DateTime.now(),
    );

    final res = await _communityRepository.applyToCreateCommunity(application);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Application successful');
        Routemaster.of(context).pop();
      },
    );
  }

  void joinBUSACommunity(BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    res = await _communityRepository.joinCommunity('busa_official', user.uid);

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        Routemaster.of(context).push('/');
      },
    );
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, 'You have left the komyuniti');
        } else {
          Routemaster.of(context).push('/');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<List<Community>> getUserOwnCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserOwnCommunities(uid);
  }

  Stream<List<ApplicationModel>> getApprovals() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getApprovals(uid);
  }

  Stream<List<ApplicationModel>> getPendingApprovals() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getPending(uid);
  }

  Stream<List<ApplicationModel>> getApprovedApprovals() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getApproved(uid);
  }

  Stream<List<ApplicationModel>> getrejectedApprovals() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getRejected(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required BuildContext context,
    required File? profileFile,
    required Community community,
    required File? bannerFile,
  }) async {
    state = true;
    if (profileFile != null) {
      // store file in communities/profile/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      // store file in communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Done!');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
    String communityName,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
