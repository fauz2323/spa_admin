// To parse this JSON data, do
//
//     final historyPointModel = historyPointModelFromJson(jsonString);

import 'dart:convert';

AddPointsModel addPointsModelFromJson(String str) =>
    AddPointsModel.fromJson(json.decode(str));

String addPointsModelToJson(AddPointsModel data) =>
    json.encode(data.toJson());

class AddPointsModel {
  final String status;
  final String message;

  AddPointsModel({required this.status, required this.message});

  factory AddPointsModel.fromJson(Map<String, dynamic> json) =>
      AddPointsModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
