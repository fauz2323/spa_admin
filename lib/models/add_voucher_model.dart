// To parse this JSON data, do
//
//     final addVoucherModel = addVoucherModelFromJson(jsonString);

import 'dart:convert';

AddVoucherModel addVoucherModelFromJson(String str) =>
    AddVoucherModel.fromJson(json.decode(str));

String addVoucherModelToJson(AddVoucherModel data) =>
    json.encode(data.toJson());

class AddVoucherModel {
  final String status;
  final String message;
  final Data data;

  AddVoucherModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddVoucherModel.fromJson(Map<String, dynamic> json) =>
      AddVoucherModel(
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
  final int id;
  final String name;
  final String price;
  final String discountAmount;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.price,
    required this.discountAmount,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    discountAmount: json["discount_amount"],
    expiryDate: DateTime.parse(json["expiry_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "discount_amount": discountAmount,
    "expiry_date":
        "${expiryDate.year.toString().padLeft(4, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
