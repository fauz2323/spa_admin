// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';
import 'user.dart';

CreateUserModel createUserModelFromJson(String str) =>
    CreateUserModel.fromJson(json.decode(str));

String createUserModelModelToJson(CreateUserModel data) =>
    json.encode(data.toJson());

class CreateUserModel {
  final bool success;
  final String message;
  final Data data;

  CreateUserModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      CreateUserModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final User user;

  Data({required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"user": user.toJson()};
}

class Point {
  final int id;
  final int userId;
  final int points;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Point({
    required this.id,
    required this.userId,
    required this.points,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    id: json["id"],
    userId: json["user_id"],
    points: json["points"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "points": points,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
