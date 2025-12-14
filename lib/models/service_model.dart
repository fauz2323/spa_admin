// To parse this JSON data, do
//
//     final spaServiceModel = spaServiceModelFromJson(jsonString);

import 'dart:convert';

SpaServiceModel spaServiceModelFromJson(String str) =>
    SpaServiceModel.fromJson(json.decode(str));

String spaServiceModelToJson(SpaServiceModel data) =>
    json.encode(data.toJson());

class SpaServiceModel {
  final bool success;
  final String message;
  final Data data;

  SpaServiceModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SpaServiceModel.fromJson(Map<String, dynamic> json) =>
      SpaServiceModel(
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
  final List<Service> services;

  Data({required this.services});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    services: List<Service>.from(
      json["services"].map((x) => Service.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
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
