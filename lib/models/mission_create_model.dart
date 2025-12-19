// To parse this JSON data, do
//
//     final missionCreateModel = missionCreateModelFromJson(jsonString);

import 'dart:convert';

MissionCreateModel missionCreateModelFromJson(String str) =>
    MissionCreateModel.fromJson(json.decode(str));

String missionCreateModelToJson(MissionCreateModel data) =>
    json.encode(data.toJson());

class MissionCreateModel {
  final String status;
  final String message;
  final Data data;

  MissionCreateModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MissionCreateModel.fromJson(Map<String, dynamic> json) =>
      MissionCreateModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final String title;
  final String description;
  final String points;
  final int goal;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  Data({
    required this.title,
    required this.description,
    required this.points,
    required this.goal,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    description: json["description"],
    points: json["points"],
    goal: json["goal"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "points": points,
    "goal": goal,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
