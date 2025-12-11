import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:spa_admin/dto/login_dto.dart';
import 'package:spa_admin/models/login_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:spa_admin/models/profile_model.dart';

class AuthNetwork {
  Future<Either<NetworkModel, LoginModel>> loginUser(LoginDto loginDto) async {
    Map body = {'email': loginDto.email, 'password': loginDto.password};

    final response = await http.post(
      Uri.parse('https://rumah.nurfauzan.site/api/login'),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginModel = LoginModel.fromJson(jsonData);
      return Right(loginModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Login failed',
      ),
    );
  }

  Future<Either<NetworkModel, ProfileModel>> profile(String token) async {
    final response = await http.get(
      Uri.parse('https://rumah.nurfauzan.site/api/profile'),
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
      final profileModel = ProfileModel.fromJson(jsonData);
      return Right(profileModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch profile',
      ),
    );
  }
}
