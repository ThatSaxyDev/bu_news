import 'package:bu_news/admin/features/verifications/repositories/verifications_repository.dart';
import 'package:bu_news/core/providers/storage_repository_provider.dart';
import 'package:bu_news/models/verification_model.dart';
import 'package:bu_news/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPendingVerificationsProvider = StreamProvider((ref) {
  final verificationController =
      ref.watch(verificationControllerProvider.notifier);
  return verificationController.getPendingVerifications();
});

final getApprovedVerificationsProvider = StreamProvider((ref) {
  final verificationController =
      ref.watch(verificationControllerProvider.notifier);
  return verificationController.getApprovedVerifications();
});

final getRejectedVerificationsProvider = StreamProvider((ref) {
  final verificationController =
      ref.watch(verificationControllerProvider.notifier);
  return verificationController.getRejectedVerifications();
});

final verificationControllerProvider =
    StateNotifierProvider<VerificationController, bool>((ref) {
  final verificationRepository = ref.watch(verificationRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return VerificationController(
    verificationRepository: verificationRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class VerificationController extends StateNotifier<bool> {
  final VerificationRepository _verificationRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  VerificationController({
    required VerificationRepository verificationRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _verificationRepository = verificationRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void approveApplication(
    BuildContext context,
    VerificationModel verification,
  ) async {
    state = true;
    final res = await _verificationRepository.giveApproval(verification);
    await _verificationRepository.editUserProfile(
      verification.userId,
      verification.matricNo,
      verification.photoIdCard,
      verification.phoneNumber,
    );
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Approved');
        // Routemaster.of(context).pop();
      },
    );
  }

  void rejectApplication(
    BuildContext context,
    VerificationModel verification,
    String reason,
  ) async {
    state = true;
    final res =
        await _verificationRepository.rejectApplication(verification, reason);
    state = false;
    res.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        showSnackBar(context, 'Rejected');
        // Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<VerificationModel>> getPendingVerifications() {
    return _verificationRepository.getPendingVerifications();
  }

  Stream<List<VerificationModel>> getApprovedVerifications() {
    return _verificationRepository.getApprovedVerifications();
  }

  Stream<List<VerificationModel>> getRejectedVerifications() {
    return _verificationRepository.getRejectedVerifications();
  }
}
