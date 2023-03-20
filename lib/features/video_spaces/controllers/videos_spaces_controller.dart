import 'dart:developer';

import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/features/community/controllers/communtiy_controller.dart';
import 'package:bu_news/features/video_spaces/repository/video_spaces_repository.dart';
import 'package:bu_news/features/video_spaces/views/video_spaces_view.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:bu_news/models/video_call_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/firebase_provider.dart';

final fetchVideoSPacesProvider = StreamProvider((ref) {
  final videoController = ref.watch(videoSpacesControllerProvider.notifier);
  return videoController.fetchVideosSpaces();
});

final videoSpacesControllerProvider =
    StateNotifierProvider<VideoSpacesController, bool>((ref) {
  final videoSpacesRepository = ref.watch(videoSpacesRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return VideoSpacesController(
    videoSpacesRepository: videoSpacesRepository,
    storageRepository: storageRepository,
    auth: ref.read(authProvider),
    ref: ref,
  );
});

class VideoSpacesController extends StateNotifier<bool> {
  final VideoSpacesRepository _videoSpacesRepository;
  final StorageRepository _storageRepository;
  final FirebaseAuth _auth;
  final Ref _ref;
  VideoSpacesController({
    required VideoSpacesRepository videoSpacesRepository,
    required StorageRepository storageRepository,
    required FirebaseAuth auth,
    required Ref ref,
  })  : _videoSpacesRepository = videoSpacesRepository,
        _storageRepository = storageRepository,
        _auth = auth,
        _ref = ref,
        super(false);

  Stream<List<VideoCallModel>> fetchVideosSpaces() {
    return _videoSpacesRepository.fetchAllVideoSpaces();
  }

  void createVideoSpace({
    required BuildContext context,
    required String receiverName,
    required String receiverUid,
    required String receiverProfilePic,
  }) async {
    try {
      state = true;

      // log(userId);
      // _ref.read(getCommunityByNameProvider(receiverName)).whenData((community) {
      //   for (var id in community.members) {
      //     _ref.read(getUserProvider(_auth.currentUser!.uid)).whenData((user) {
      //       callId = const Uuid().v1();
      //       senderCallData = VideoCallModel(
      //         callerId: user.uid,
      //         callerName: user.name,
      //         callerPic: user.profilePic,
      //         receiverId: receiverUid,
      //         receiverName: receiverName,
      //         receiverPic: receiverProfilePic,
      //         callId: callId,
      //         hasDialled: true,
      //       );

      //       receiverCallData = VideoCallModel(
      //         callerId: user.uid,
      //         callerName: user.name,
      //         callerPic: user.profilePic,
      //         receiverId: receiverUid,
      //         receiverName: receiverName,
      //         receiverPic: receiverProfilePic,
      //         callId: callId,
      //         hasDialled: false,
      //       );
      //     });
      //   }
      // });

      _ref.read(getUserProvider(_auth.currentUser!.uid)).whenData((user) {
        String callId = const Uuid().v1();
        VideoCallModel senderCallData = VideoCallModel(
          callerId: _auth.currentUser!.uid,
          callerName: user.name,
          callerPic: user.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: true,
        );

        VideoCallModel receiverCallData = VideoCallModel(
          callerId: _auth.currentUser!.uid,
          callerName: user.name,
          callerPic: user.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: false,
        );
        _videoSpacesRepository.createVideoSpace(
          senderCallData,
          receiverCallData,
          context,
        );
      });
      // _videoSpacesRepository.createVideoSpace(
      //   senderCallData,
      //   receiverCallData,
      //   context,
      // );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void leaveSpace({
    required String callerId,
    required String receiverId,
    required BuildContext context,
  }) async {
    state = true;
    final res =
        await _videoSpacesRepository.leaveVideoSPace(callerId, receiverId);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) => Routemaster.of(context).pop(),
    );
  }
}
