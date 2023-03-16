import 'package:bu_news/admin/features/communities/repositories/community_repository.dart';
import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/utils.dart';

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
}
