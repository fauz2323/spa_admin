// To parse this JSON data, do
//
//     final listMissionModel = listMissionModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

ListMissionModel listMissionModelFromJson(String str) =>
    ListMissionModel.fromJson(json.decode(str));

String listMissionModelToJson(ListMissionModel data) =>
    json.encode(data.toJson());

class ListMissionModel {
  final String status;
  final String message;
  final List<Datum> data;

  ListMissionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ListMissionModel.fromJson(Map<String, dynamic> json) =>
      ListMissionModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final int id;
  final String title;
  final String description;
  final String points;
  final int goal;
  final DateTime expiredDate;
  final String? services;
  final DateTime createdAt;
  final DateTime updatedAt;

  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.goal,
    required this.expiredDate,
    required this.createdAt,
    required this.updatedAt,
    this.services,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    points: json["points"],
    goal: json["goal"],
    expiredDate: DateTime.parse(json["expired_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    services: json["services"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "points": points,
    "goal": goal,
    "expired_date": DateFormat('yyyy-MM-dd').format(expiredDate),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "services": services,
  };
}
