import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/models/dashboard_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;
import 'package:spa_admin/models/pending_orders_model.dart';

class HomeNetwork {
  Future<Either<NetworkModel, DashboardModel>> dashboard(String token) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/dashboard'),
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
      final dashboardModel = DashboardModel.fromJson(jsonData);
      return Right(dashboardModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Dashboard fetch failed',
      ),
    );
  }

  Future<Either<NetworkModel, PendingOrdersModel>> pendingOrders(
    String token,
    String status,
  ) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/orders/$status'),
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
      final pendingOrdersModel = PendingOrdersModel.fromJson(jsonData);
      return Right(pendingOrdersModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Pending orders fetch failed',
      ),
    );
  }
}
