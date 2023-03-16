// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminModel {
  final String uid;
  final String name;
  final String profilePic;
  const AdminModel({
    required this.uid,
    required this.name,
    required this.profilePic,
  });

  AdminModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
  }) {
    return AdminModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map["uid"] ?? '',
      name: map["name"] ?? '',
      profilePic: map["profilePic"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) => AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AdminModel(uid: $uid, name: $name, profilePic: $profilePic)';

  @override
  bool operator ==(covariant AdminModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.name == name &&
      other.profilePic == profilePic;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ profilePic.hashCode;
}
