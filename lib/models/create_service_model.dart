// To parse this JSON data, do
//
//     final createServiceModel = createServiceModelFromJson(jsonString);

import 'dart:convert';

CreateServiceModel createServiceModelFromJson(String str) =>
    CreateServiceModel.fromJson(json.decode(str));

String createServiceModelToJson(CreateServiceModel data) =>
    json.encode(data.toJson());

class CreateServiceModel {
  final bool success;
  final String message;
  final Data data;

  CreateServiceModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateServiceModel.fromJson(Map<String, dynamic> json) =>
      CreateServiceModel(
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
  final String name;
  final String description;
  final String price;
  final int duration;
  final bool isActive;
  final String uuid;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  Service({
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.uuid,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    duration: json["duration"],
    isActive: json["is_active"],
    uuid: json["uuid"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "duration": duration,
    "is_active": isActive,
    "uuid": uuid,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
