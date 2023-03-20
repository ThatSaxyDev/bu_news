// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VideoCallModel {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;
  const VideoCallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialled,
  });

  VideoCallModel copyWith({
    String? callerId,
    String? callerName,
    String? callerPic,
    String? receiverId,
    String? receiverName,
    String? receiverPic,
    String? callId,
    bool? hasDialled,
  }) {
    return VideoCallModel(
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerPic: callerPic ?? this.callerPic,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverPic: receiverPic ?? this.receiverPic,
      callId: callId ?? this.callId,
      hasDialled: hasDialled ?? this.hasDialled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialled': hasDialled,
    };
  }

  factory VideoCallModel.fromMap(Map<String, dynamic> map) {
    return VideoCallModel(
      callerId: map["callerId"] ?? '',
      callerName: map["callerName"] ?? '',
      callerPic: map["callerPic"] ?? '',
      receiverId: map["receiverId"] ?? '',
      receiverName: map["receiverName"] ?? '',
      receiverPic: map["receiverPic"] ?? '',
      callId: map["callId"] ?? '',
      hasDialled: map["hasDialled"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoCallModel.fromJson(String source) =>
      VideoCallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoCallModel(callerId: $callerId, callerName: $callerName, callerPic: $callerPic, receiverId: $receiverId, receiverName: $receiverName, receiverPic: $receiverPic, callId: $callId, hasDialled: $hasDialled)';
  }

  @override
  bool operator ==(covariant VideoCallModel other) {
    if (identical(this, other)) return true;

    return other.callerId == callerId &&
        other.callerName == callerName &&
        other.callerPic == callerPic &&
        other.receiverId == receiverId &&
        other.receiverName == receiverName &&
        other.receiverPic == receiverPic &&
        other.callId == callId &&
        other.hasDialled == hasDialled;
  }

  @override
  int get hashCode {
    return callerId.hashCode ^
        callerName.hashCode ^
        callerPic.hashCode ^
        receiverId.hashCode ^
        receiverName.hashCode ^
        receiverPic.hashCode ^
        callId.hashCode ^
        hasDialled.hashCode;
  }
}
