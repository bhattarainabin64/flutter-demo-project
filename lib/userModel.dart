import 'package:tech/profile.dart';

class UserModel {
  final String? uid;
  final String fullName;
  final String email;
  final String phone;
  final DateTime createdAt;
  final String? pic;

  UserModel({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.pic
  });

  // Create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      pic: json['pic'],
      
    );
  }

  // Convert a UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'pic': pic,
    };
  }
}
