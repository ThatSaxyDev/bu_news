import 'package:bu_news/admin/models/admin_model.dart';
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final adminAuthRepositoryProvider = Provider(
  (ref) => AdminAuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AdminAuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AdminAuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _admin =>
      _firestore.collection(FirebaseConstants.adminCollection);

  Stream<User?> get adminAuthStateChange => _auth.authStateChanges();

  FutureEither<AdminModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      // if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      // } else {
      //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //   final googleAuth = await googleUser?.authentication;

      //   final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth?.accessToken,
      //     idToken: googleAuth?.idToken,
      //   );

      //   userCredential = await _auth.signInWithCredential(credential);
      // }

      AdminModel adminModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        adminModel = AdminModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          // banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
          // matricNo: '',
          // schoolName: '',
          // isACourseRep: false,
          // isALead: false,
          // email: userCredential.user!.email ?? '',
        );
        await _admin.doc(userCredential.user!.uid).set(adminModel.toMap());
      } else {
        adminModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(adminModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<AdminModel> getUserData(String uid) {
    return _admin.doc(uid).snapshots().map(
        (event) => AdminModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
