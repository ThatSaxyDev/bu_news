// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/admin/models/community_model.dart';
import 'package:bu_news/core/constants/firebase_constants.dart';
import 'package:bu_news/core/failure.dart';
import 'package:bu_news/core/providers/firebase_provider.dart';
import 'package:bu_news/core/type_defs.dart';
import 'package:bu_news/models/application_model.dart';
import 'package:bu_news/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // FutureVoid createCommunity(Community community) async {
  //   try {
  //     var communityDoc = await _communities.doc(community.name).get();
  //     if (communityDoc.exists) {
  //       throw 'Komyuniti with the same name exists';
  //     }

  //     return right(_communities.doc(community.name).set(community.toMap()));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  FutureVoid applyToCreateCommunity(ApplicationModel application) async {
    try {
      var communityDoc =
          await _communities.doc(application.communityName).get();
      if (communityDoc.exists) {
        throw 'Community with the same name exists';
      }
      return right(
          _approvals.doc(application.communityName).set(application.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityname, String userId) async {
    try {
      return right(_communities.doc(communityname).update(
        {
          'members': FieldValue.arrayUnion([userId]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityname, String userId) async {
    try {
      return right(_communities.doc(communityname).update(
        {
          'members': FieldValue.arrayRemove([userId]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<Community> communities = [];
        for (var doc in event.docs) {
          communities
              .add(Community.fromMap(doc.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<List<Community>> getUserOwnCommunities(String uid) {
    return _communities.where('mods', arrayContains: uid).snapshots().map(
      (event) {
        List<Community> communities = [];
        for (var doc in event.docs) {
          communities
              .add(Community.fromMap(doc.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<List<ApplicationModel>> getApprovals(String uid) {
    return _approvals.where('userId', isEqualTo: uid).snapshots().map((event) {
      List<ApplicationModel> applications = [];
      for (var doc in event.docs) {
        applications
            .add(ApplicationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return applications;
    });
  }

  //! get pending applications
  Stream<List<ApplicationModel>> getPending(String uid) {
    return _approvals
        .where('userId', isEqualTo: uid)
        .where('approvalStatus', isEqualTo: 'pending')
        .snapshots()
        .map((event) {
      List<ApplicationModel> applications = [];
      for (var doc in event.docs) {
        applications
            .add(ApplicationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return applications;
    });
  }

  //! get approvedApplications
  Stream<List<ApplicationModel>> getApproved(String uid) {
    return _approvals
        .where('userId', isEqualTo: uid)
        .where('approvalStatus', isEqualTo: 'approved')
        .snapshots()
        .map((event) {
      List<ApplicationModel> applications = [];
      for (var doc in event.docs) {
        applications
            .add(ApplicationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return applications;
    });
  }

  //! get rejected Applications
  Stream<List<ApplicationModel>> getRejected(String uid) {
    return _approvals
        .where('userId', isEqualTo: uid)
        .where('approvalStatus', isEqualTo: 'rejected')
        .snapshots()
        .map((event) {
      List<ApplicationModel> applications = [];
      for (var doc in event.docs) {
        applications
            .add(ApplicationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return applications;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

//! edit community
  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query.toLowerCase(),
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  CollectionReference get _approvals =>
      _firestore.collection(FirebaseConstants.approvalCollection);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
