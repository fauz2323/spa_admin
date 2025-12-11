// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  final bool success;
  final String message;
  final Data data;

  DashboardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
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
  final int totalCustomers;
  final int pendingServices;
  final int completedServices;
  final int dailyServices;

  Data({
    required this.totalCustomers,
    required this.pendingServices,
    required this.completedServices,
    required this.dailyServices,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalCustomers: json["total_customers"],
    pendingServices: json["pending_services"],
    completedServices: json["completed_services"],
    dailyServices: json["daily_services"],
  );

  Map<String, dynamic> toJson() => {
    "total_customers": totalCustomers,
    "pending_services": pendingServices,
    "completed_services": completedServices,
    "daily_services": dailyServices,
  };
}
