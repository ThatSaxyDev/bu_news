import 'dart:developer';

import 'package:bu_news/features/auth/repository/auth_repository.dart';
import 'package:bu_news/features/community/repository/community_repository.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider),
      communityRepository: ref.watch(communityRepositoryProvider),
      ref: ref),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final CommunityRepository _communityRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _communityRepository = communityRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    late UserModel userM;
    final user = await _authRepository.signInWithGoogle();
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userM = userModel),
    );

    // join busa
    final res =
        await _communityRepository.joinCommunity('busa_official', userM.uid);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        log('');
      },
    );
  }

  void signInWithGoogleAdmin(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogleAdmin();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
