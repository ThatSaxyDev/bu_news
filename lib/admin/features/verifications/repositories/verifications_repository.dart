import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/models/application_model.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:bu_news/models/verification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final verificationRepositoryProvider = Provider((ref) {
  return VerificationRepository(firestore: ref.watch(firestoreProvider));
});

class VerificationRepository {
  final FirebaseFirestore _firestore;
  VerificationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // get verifications
  Stream<List<VerificationModel>> getPendingVerifications() {
    return _verifications
        .where('verificationStatus', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                VerificationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //! give approval
  FutureVoid giveApproval(VerificationModel verification) async {
    try {
      _users.doc(verification.userId).update({'schoolName': 'approved'});
      return right(_verifications
          .doc(verification.userId)
          .update({'verificationStatus': 'approved'}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! set user matric number and id card
  FutureVoid editUserProfile(
      String userId, String matricNo, String idCard) async {
    try {
      return right(_users.doc(userId).update({
        'matricNo': matricNo,
        'studentIdCard': idCard,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! reject application
  FutureVoid rejectApplication(
      VerificationModel verification, String reason) async {
    try {
      _users.doc(verification.userId).update({'schoolName': 'rejected'});
      return right(_verifications.doc(verification.userId).update({
        'verificationStatus': 'rejected',
        'description':
            'Your last verification application failed due to $reason',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // get approved verifications
  Stream<List<VerificationModel>> getApprovedVerifications() {
    return _verifications
        .where('verificationStatus', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                VerificationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  // get rejected verifications
  Stream<List<VerificationModel>> getRejectedVerifications() {
    return _verifications
        .where('verificationStatus', isEqualTo: 'rejected')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                VerificationModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  CollectionReference get _verifications =>
      _firestore.collection(FirebaseConstants.verificationCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
