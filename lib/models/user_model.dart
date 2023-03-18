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
  final String studentIdCard;
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
    required this.studentIdCard,
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
    String? studentIdCard,
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
      studentIdCard: studentIdCard ?? this.studentIdCard,
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
      'studentIdCard': studentIdCard,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map["uid"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      email: (map["email"] ?? '') as String,
      profilePic: (map["profilePic"] ?? '') as String,
      banner: (map["banner"] ?? '') as String,
      matricNo: (map["matricNo"] ?? '') as String,
      schoolName: (map["schoolName"] ?? '') as String,
      isACourseRep: (map["isACourseRep"] ?? false) as bool,
      isALead: (map["isALead"] ?? false) as bool,
      studentIdCard: (map["studentIdCard"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, profilePic: $profilePic, banner: $banner, matricNo: $matricNo, schoolName: $schoolName, isACourseRep: $isACourseRep, isALead: $isALead, studentIdCard: $studentIdCard)';
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
        other.isALead == isALead &&
        other.studentIdCard == studentIdCard;
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
        isALead.hashCode ^
        studentIdCard.hashCode;
  }
}
