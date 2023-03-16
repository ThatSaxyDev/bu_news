import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final adminPostRepositoryProvider = Provider((ref) {
  return AdminPostRepository(firestore: ref.watch(firestoreProvider));
});

class AdminPostRepository {
  final FirebaseFirestore _firestore;
  AdminPostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // add posts for everyone to view
  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
