import 'dart:developer';

import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/features/video_spaces/views/video_spaces_view.dart';
import 'package:bu_news/models/video_call_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final videoSpacesRepositoryProvider = Provider((ref) {
  return VideoSpacesRepository(firestore: ref.watch(firestoreProvider));
});

class VideoSpacesRepository {
  final FirebaseFirestore _firestore;
  VideoSpacesRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  void createVideoSpace(
    VideoCallModel senderCallData,
    VideoCallModel receiverCallData,
    BuildContext context,
  ) async {
    try {
      await _videospaces
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var communityDoc =
          await _communities.doc(senderCallData.receiverId).get();

      Map<String, dynamic>? communityData =
          communityDoc.data() as Map<String, dynamic>?;

      Community community = Community.fromMap(communityData!);

      for (var id in community.members) {
        // log(id);
        await _videospaces.doc(id).set(receiverCallData.toMap());
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoSpacesView(
            channelId: senderCallData.callId,
            videoSpace: senderCallData,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  FutureVoid leaveVideoSPace(
    String callerId,
    String receiverId,
  ) async {
    try {
      final res = await _videospaces.doc(callerId).delete();

      var communityDoc = await _communities.doc(receiverId).get();

      Map<String, dynamic>? communityData =
          communityDoc.data() as Map<String, dynamic>?;

      Community community = Community.fromMap(communityData!);

      for (var id in community.members) {
        await _videospaces.doc(id).delete();
      }

      return right(res);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<VideoCallModel>> fetchAllVideoSpaces() {
    return _videospaces.snapshots().map((event) {
      List<VideoCallModel> videoSpaces = [];
      for (var doc in event.docs) {
        videoSpaces
            .add(VideoCallModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return videoSpaces;
    });
  }

  CollectionReference get _videospaces =>
      _firestore.collection(FirebaseConstants.videoSpaceCollection);

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
