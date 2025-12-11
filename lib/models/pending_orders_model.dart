// To parse this JSON data, do
//
//     final pendingOrdersModel = pendingOrdersModelFromJson(jsonString);

import 'dart:convert';

PendingOrdersModel pendingOrdersModelFromJson(String str) =>
    PendingOrdersModel.fromJson(json.decode(str));

String pendingOrdersModelToJson(PendingOrdersModel data) =>
    json.encode(data.toJson());

class PendingOrdersModel {
  final bool success;
  final String message;
  final List<Datum> data;

  PendingOrdersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PendingOrdersModel.fromJson(Map<String, dynamic> json) =>
      PendingOrdersModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final int id;
  final int userId;
  final int spaServicesId;
  final String status;
  final String price;
  final String timeService;
  final String dateService;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final SpaService spaService;

  Datum({
    required this.id,
    required this.userId,
    required this.spaServicesId,
    required this.status,
    required this.price,
    required this.timeService,
    required this.dateService,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.spaService,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    spaServicesId: json["spa_services_id"],
    status: json["status"],
    price: json["price"],
    timeService: json["time_service"],
    dateService: json["date_service"],
    notes: json["notes"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
    spaService: SpaService.fromJson(json["spa_service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "spa_services_id": spaServicesId,
    "status": status,
    "price": price,
    "time_service": timeService,
    "date_service": dateService,
    "notes": notes,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "spa_service": spaService.toJson(),
  };
}

class SpaService {
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

  SpaService({
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

  factory SpaService.fromJson(Map<String, dynamic> json) => SpaService(
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

class User {
  final int id;
  final String name;
  final String email;
  final dynamic emailVerifiedAt;
  final String phone;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "role": role,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
