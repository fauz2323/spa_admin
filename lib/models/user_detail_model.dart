// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  final bool success;
  final String message;
  final Data data;

  UserDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
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
  final int id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final DateTime createdAt;
  final Point point;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.createdAt,
    required this.point,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    phone: json["phone"],
    createdAt: DateTime.parse(json["created_at"]),
    point: Point.fromJson(json["point"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "phone": phone,
    "created_at": createdAt.toIso8601String(),
    "point": point.toJson(),
  };
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
