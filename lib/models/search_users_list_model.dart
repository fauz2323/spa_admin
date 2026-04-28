// To parse this JSON data, do
//
//     final SearchUsersListModel = SearchUsersListModelFromJson(jsonString);

import 'dart:convert';
import 'user.dart';

SearchUsersListModel SearchUsersListModelFromJson(String str) =>
    SearchUsersListModel.fromJson(json.decode(str));

String SearchUsersListModelToJson(SearchUsersListModel data) => json.encode(data.toJson());

class SearchUsersListModel {
  final bool success;
  final String message;
  final List<User> data;

  SearchUsersListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SearchUsersListModel.fromJson(Map<String, dynamic> json) => SearchUsersListModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
