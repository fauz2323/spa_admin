import 'package:dartz/dartz.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:spa_admin/models/users_list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spa_admin/models/users_points_model.dart';

class UsersManagementNetwork {
  Future<Either<NetworkModel, UsersListModel>> usersList(String token) async {
    final response = await http.get(
      Uri.parse('https://rumah.nurfauzan.site/api/admin/users'),
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
      final usersListModel = UsersListModel.fromJson(jsonData);
      return Right(usersListModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch users list',
      ),
    );
  }

  Future<Either<NetworkModel, UsersPointsModel>> usersPoints(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('https://rumah.nurfauzan.site/api/admin/users/points'),
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
      final usersPointsModel = UsersPointsModel.fromJson(jsonData);
      return Right(usersPointsModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch users points',
      ),
    );
  }
}
