// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/core/constants/constants.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final userEmail = userCredential.user!.email;
      if (!userEmail!.contains('@student.babcock.edu.ng')) {
        return left(Failure('Not a babcock mail'));
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
          matricNo: '',
          schoolName: '',
          isACourseRep: false,
          isALead: false,
          email: userCredential.user!.email ?? '',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

   FutureEither<UserModel> signInWithGoogleAdmin() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final userEmail = userCredential.user!.email;
      if (userEmail != 'bunewsa@gmail.com') {
        return left(Failure('Error!'));
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
          matricNo: '',
          schoolName: '',
          isACourseRep: false,
          isALead: false,
          email: userCredential.user!.email ?? '',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
