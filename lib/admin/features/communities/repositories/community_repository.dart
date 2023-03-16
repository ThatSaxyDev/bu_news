import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final adminCommunityRepositoryProvider = Provider((ref) {
  return AdminCommunityRepository(firestore: ref.watch(firestoreProvider));
});

class AdminCommunityRepository {
  final FirebaseFirestore _firestore;
  AdminCommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! create community
  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Komyuniti with the same name exists';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
