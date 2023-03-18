import 'package:bu_news/admin/features/communities/repositories/community_repository.dart';
import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/models/application_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/utils.dart';

final getPendingApplicationsProvider = StreamProvider((ref) {
  final communityController =
      ref.watch(adminCommunityControllerProvider.notifier);
  return communityController.getPendingAPplications();
});

final getApprovedApplicationsProvider = StreamProvider((ref) {
  final communityController =
      ref.watch(adminCommunityControllerProvider.notifier);
  return communityController.getApprovedApplications();
});

final getRejectedApplicationsProvider = StreamProvider((ref) {
  final communityController =
      ref.watch(adminCommunityControllerProvider.notifier);
  return communityController.getRejectedApplications();
});

final adminCommunityControllerProvider =
    StateNotifierProvider<AdminCommunityController, bool>((ref) {
  final communityRepository = ref.watch(adminCommunityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return AdminCommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class AdminCommunityController extends StateNotifier<bool> {
  final AdminCommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  AdminCommunityController({
    required AdminCommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // create community
  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.communityAvatarDefault,
      members: [uid],
      mods: [uid],
      description: ''
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Komyuniti created successfully');
        // Routemaster.of(context).pop();
      },
    );
  }

  //! approve application to create community
  void approveApplication(
      BuildContext context, ApplicationModel application) async {
    state = true;
    await _communityRepository.giveApproval(application);

    Community community = Community(
      id: application.communityName,
      name: application.communityName,
      banner: Constants.bannerDefault,
      avatar: Constants.communityAvatarDefault,
      members: [application.userId],
      mods: [application.userId],
      description: '',
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Approved');
        // Routemaster.of(context).pop();
      },
    );
  }

  void rejectApplication(
    BuildContext context,
    ApplicationModel application,
  ) async {
    state = true;
    final res = await _communityRepository.rejectApplication(application);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Rejected');
        // Routemaster.of(context).pop();
      },
    );
  }

  //! get applications
  Stream<List<ApplicationModel>> getPendingAPplications() {
    return _communityRepository.getPendingApplications();
  }

  Stream<List<ApplicationModel>> getApprovedApplications() {
    return _communityRepository.getApprovedApplications();
  }

  Stream<List<ApplicationModel>> getRejectedApplications() {
    return _communityRepository.getRejectedApplications();
  }
}
