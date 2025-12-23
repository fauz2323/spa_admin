import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/dto/create_mission_dto.dart';
import 'package:spa_admin/models/list_mission_model.dart';
import 'package:spa_admin/models/mission_create_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;

class MissionNetwork {
  Future<Either<NetworkModel, ListMissionModel>> getMissions(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/missions'),
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
      final missions = ListMissionModel.fromJson(jsonData);
      return Right(missions);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch missions',
      ),
    );
  }

  Future<NetworkModel> deleteMission(String token, String id) async {
    Map body = {'id': id};
    final response = await http.post(
      Uri.parse('https://rizky-firman.com/api/admin/missions'),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonData = jsonDecode(response.body);

    return NetworkModel(
      statusCode: response.statusCode,
      message: jsonData['message'] ?? 'Failed to fetch missions',
    );
  }

  Future<Either<NetworkModel, MissionCreateModel>> createMission(
    String token,
    CreateMissionDto dto,
  ) async {
    late Map body;
    late Uri uri;

    print('DTO ID: ${dto.id}');
    if (dto.id != null) {
      uri = Uri.parse('https://rizky-firman.com/api/admin/missions/edit');
      body = {
        'id': dto.id,
        'title': dto.title,
        'description': dto.description,
        'points': dto.points.toString(),
        'goal': dto.goal,
      };
    } else {
      uri = Uri.parse('https://rizky-firman.com/api/admin/missions/create');
      body = {
        'title': dto.title,
        'description': dto.description,
        'points': dto.points.toString(),
        'goal': dto.goal,
      };
    }

    final response = await http.post(
      uri,
      body: jsonEncode(body),
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
      final missions = MissionCreateModel.fromJson(jsonData);
      return Right(missions);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch missions',
      ),
    );
  }

  Future<Either<NetworkModel, MissionCreateModel>> getMission(
    String token,
    String id,
  ) async {
    Map body = {'id': id};
    final response = await http.post(
      Uri.parse('https://rizky-firman.com/api/admin/missions/detail'),
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
      final missions = MissionCreateModel.fromJson(jsonData);
      return Right(missions);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch missions',
      ),
    );
  }
}
