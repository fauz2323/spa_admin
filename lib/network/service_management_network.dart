import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/dto/create_service_dto.dart';
import 'package:spa_admin/models/create_service_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:spa_admin/models/service_detail_model.dart';
import 'package:spa_admin/models/service_model.dart';
import 'package:http/http.dart' as http;

class ServiceManagementNetwork {
  Future<Either<NetworkModel, SpaServiceModel>> getSpaService(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/spa-services'),
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
      final spaServiceModel = SpaServiceModel.fromJson(jsonData);
      return Right(spaServiceModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch spa services list',
      ),
    );
  }

  Future<Either<NetworkModel, ServiceDetailModel>> getSpaServiceDetail(
    String token,
    String id,
  ) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/spa-service/detail/$id'),
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
      final spaServiceModel = ServiceDetailModel.fromJson(jsonData);
      return Right(spaServiceModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch spa services list',
      ),
    );
  }

  Future<Either<NetworkModel, NetworkModel>> deleteSpaService(
    String token,
    String id,
  ) async {
    final response = await http.delete(
      Uri.parse('https://rizky-firman.com/api/admin/spa-services/$id/delete'),
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
      final spaServiceModel = NetworkModel(
        statusCode: 200,
        message: 'success Delete',
      );
      return Right(spaServiceModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch spa services list',
      ),
    );
  }

  Future<Either<NetworkModel, CreateServiceModel>> create(
    String token,
    CreateServiceDto data,
  ) async {
    final response = await http.post(
      Uri.parse('https://rizky-firman.com/api/admin/spa-services/create'),
      body: jsonEncode(data.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final createData = CreateServiceModel.fromJson(jsonData);
      return Right(createData);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch spa services list',
      ),
    );
  }
}
