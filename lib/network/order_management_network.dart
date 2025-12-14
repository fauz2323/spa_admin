import 'dart:convert';

import 'package:dartz/dartz.dart';
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
      Uri.parse('https://rumah.nurfauzan.site/api/admin/orders/view'),
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
      Uri.parse('https://rumah.nurfauzan.site/api/admin/orders/changeStatus'),
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
}
