// To parse this JSON data, do
//
//     final serviceDetailModel = serviceDetailModelFromJson(jsonString);

import 'dart:convert';

ServiceDetailModel serviceDetailModelFromJson(String str) =>
    ServiceDetailModel.fromJson(json.decode(str));

String serviceDetailModelToJson(ServiceDetailModel data) =>
    json.encode(data.toJson());

class ServiceDetailModel {
  final bool success;
  final String message;
  final Data data;

  ServiceDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) =>
      ServiceDetailModel(
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
  final Service service;

  Data({required this.service});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(service: Service.fromJson(json["service"]));

  Map<String, dynamic> toJson() => {"service": service.toJson()};
}

class Service {
  final int id;
  final String uuid;
  final String name;
  final String description;
  final String price;
  final int duration;
  final bool isActive;
  final String image;
  final String points;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.uuid,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.image,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    duration: json["duration"],
    isActive: json["is_active"],
    image: json["image"],
    points: json["points"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "description": description,
    "price": price,
    "duration": duration,
    "is_active": isActive,
    "image": image,
    "points": points,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
