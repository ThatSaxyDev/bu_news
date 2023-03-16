import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/models/application_model.dart';
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

  //! get applicatiions
  Stream<List<ApplicationModel>> getPendingApplications() {
    return _approvals
        .where('approvalStatus', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //! give approval
  FutureVoid giveApproval(ApplicationModel application) async {
    try {
      return right(_approvals
          .doc(application.communityName)
          .update({'approvalStatus': 'approved'}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! reject application
  FutureVoid rejectApplication(ApplicationModel application) async {
    try {
      return right(_approvals
          .doc(application.communityName)
          .update({'approvalStatus': 'rejected'}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! add applicant to community
  FutureVoid addApplicantToCommunity(
      ApplicationModel application, List<String> uids) async {
    try {
      return right(_approvals.doc(application.communityName).update({
        'mods': uids,
        'members': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ApplicationModel>> getApprovedApplications() {
    return _approvals
        .where('approvalStatus', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ApplicationModel>> getRejectedApplications() {
    return _approvals
        .where('approvalStatus', isEqualTo: 'rejected')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                ApplicationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //
  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _approvals =>
      _firestore.collection(FirebaseConstants.approvalCollection);
}
