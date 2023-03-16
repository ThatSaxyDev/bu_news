// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String banner;
  final String matricNo;
  final String schoolName;
  final bool isACourseRep;
  final bool isALead;
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.banner,
    required this.matricNo,
    required this.schoolName,
    required this.isACourseRep,
    required this.isALead,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    String? banner,
    String? matricNo,
    String? schoolName,
    bool? isACourseRep,
    bool? isALead,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      matricNo: matricNo ?? this.matricNo,
      schoolName: schoolName ?? this.schoolName,
      isACourseRep: isACourseRep ?? this.isACourseRep,
      isALead: isALead ?? this.isALead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'banner': banner,
      'matricNo': matricNo,
      'schoolName': schoolName,
      'isACourseRep': isACourseRep,
      'isALead': isALead,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? '',
      name: map["name"] ?? '',
      email: map["email"] ?? '',
      profilePic: map["profilePic"] ?? '',
      banner: map["banner"] ?? '',
      matricNo: map["matricNo"] ?? '',
      schoolName: map["schoolName"] ?? '',
      isACourseRep: map["isACourseRep"] ?? false,
      isALead: map["isALead"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, profilePic: $profilePic, banner: $banner, matricNo: $matricNo, schoolName: $schoolName, isACourseRep: $isACourseRep, isALead: $isALead)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.matricNo == matricNo &&
        other.schoolName == schoolName &&
        other.isACourseRep == isACourseRep &&
        other.isALead == isALead;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        matricNo.hashCode ^
        schoolName.hashCode ^
        isACourseRep.hashCode ^
        isALead.hashCode;
  }
}
