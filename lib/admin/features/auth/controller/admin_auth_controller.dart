import 'package:bu_news/admin/features/auth/repository/admin_auth_repository.dart';
import 'package:bu_news/admin/models/admin_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminProvider = StateProvider<AdminModel?>((ref) => null);

final adminAuthControllerProvider =
    StateNotifierProvider<AdminAuthController, bool>(
  (ref) => AdminAuthController(
      authRepository: ref.watch(adminAuthRepositoryProvider), ref: ref),
);

final adminAuthStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(adminAuthControllerProvider.notifier);
  return authController.adminAuthStateChange;
});

final getAdminProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(adminAuthControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AdminAuthController extends StateNotifier<bool> {
  final AdminAuthRepository _authRepository;
  final Ref _ref;
  AdminAuthController(
      {required AdminAuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get adminAuthStateChange => _authRepository.adminAuthStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (adminModel) =>
          _ref.read(adminProvider.notifier).update((state) => adminModel),
    );
  }

  Stream<AdminModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
