// To parse this JSON data, do
//
//     final listVouchersModel = listVouchersModelFromJson(jsonString);

import 'dart:convert';

ListVouchersModel listVouchersModelFromJson(String str) =>
    ListVouchersModel.fromJson(json.decode(str));

String listVouchersModelToJson(ListVouchersModel data) =>
    json.encode(data.toJson());

class ListVouchersModel {
  final String status;
  final String message;
  final List<Datum> data;

  ListVouchersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ListVouchersModel.fromJson(Map<String, dynamic> json) =>
      ListVouchersModel(
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
  final String name;
  final String price;
  final int discountAmount;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.price,
    required this.discountAmount,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
