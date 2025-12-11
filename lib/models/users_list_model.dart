// To parse this JSON data, do
//
//     final usersListModel = usersListModelFromJson(jsonString);

import 'dart:convert';

UsersListModel usersListModelFromJson(String str) =>
    UsersListModel.fromJson(json.decode(str));

String usersListModelToJson(UsersListModel data) => json.encode(data.toJson());

class UsersListModel {
  final bool success;
  final String message;
  final Data data;

  UsersListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UsersListModel.fromJson(Map<String, dynamic> json) => UsersListModel(
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
  final List<User> users;

  Data({required this.users});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(users: List<User>.from(json["users"].map((x) => User.fromJson(x))));

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  final String name;
  final String email;
  final String role;
  final String phone;
  final DateTime createdAt;
  final Point point;

  User({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.createdAt,
    required this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    role: json["role"],
    phone: json["phone"],
    createdAt: DateTime.parse(json["created_at"]),
    point: Point.fromJson(json["point"]),
  );

  Map<String, dynamic> toJson() => {
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
