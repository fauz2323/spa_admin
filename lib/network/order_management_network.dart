import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:spa_admin/models/order_detail_model.dart';
import 'package:spa_admin/models/service_detail_model.dart';
import 'package:spa_admin/models/users_list_model.dart';
import 'package:http/http.dart' as http;

class OrderManagementNetwork {
  Future<Either<NetworkModel, OrderDetailModel>> orderDetail(
    String token,
    String id,
  ) async {
    Map body = {'id': id};

    final response = await http.post(
      Uri.parse('https://rizky-firman.com/api/admin/orders/view'),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final orderDetail = OrderDetailModel.fromJson(jsonData);
      return Right(orderDetail);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch order detail',
      ),
    );
  }

  Future<Either<NetworkModel, OrderDetailModel>> changeStatus(
    String token,
    String id,
    String status,
  ) async {
    Map body = {'status': status, 'id': id};

    final response = await http.post(
      Uri.parse('https://rizky-firman.com/api/admin/orders/changeStatus'),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final orderDetail = OrderDetailModel.fromJson(jsonData);
      return Right(orderDetail);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch spa services list',
      ),
    );
  }

  Future<Either<NetworkModel, String>> downloadExcel(String token) async {
    await Permission.storage.request();

    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/orders/export'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept':
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dir = await getExternalStorageDirectory();
      final filePath = "${dir!.path}/report.xlsx";

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return Right('file saved at $filePath');
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: 'Failed to fetch spa services list',
      ),
    );
  }
}
