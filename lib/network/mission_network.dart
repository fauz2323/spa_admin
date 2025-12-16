import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/models/list_mission_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;

class MissionNetwork {
  Future<Either<NetworkModel, ListMissionModel>> getMissions(
    String token,
  ) async {
    Map body = {'id': id};

    final response = await http.get(
      Uri.parse('https://rumah.nurfauzan.site/api/admin/missions'),
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
}
