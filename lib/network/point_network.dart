import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/models/history_points_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;

class PointNetwork {
  Future<Either<NetworkModel, HistoryPointModel>> getPoint(String token) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/points/user-points'),
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
      final data = HistoryPointModel.fromJson(jsonData);
      return Right(data);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch points',
      ),
    );
  }
}
