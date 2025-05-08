// To parse this JSON data, do
//
//     final userModelInfo = userModelInfoFromJson(jsonString);

import 'dart:convert';

UserModelInfo userModelInfoFromJson(String str) =>
    UserModelInfo.fromJson(json.decode(str));

String userModelInfoToJson(UserModelInfo data) => json.encode(data.toJson());

class UserModelInfo {
  String name;
  String email;
  String school;
  String phoneNumber;
  String bio;
  String userAvatar;

  UserModelInfo({
    required this.name,
    required this.email,
    required this.school,
    required this.phoneNumber,
    required this.bio,
    required this.userAvatar,
  });

  factory UserModelInfo.fromJson(Map<String, dynamic> json) => UserModelInfo(
        name: json["name"],
        school: json["school"],
        phoneNumber: json["phoneNumber"],
        bio: json["bio"],
        userAvatar: json["userAvatar"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "school": school,
        "phoneNumber": phoneNumber,
        "bio": bio,
        "userAvatar": userAvatar,
      };
}
