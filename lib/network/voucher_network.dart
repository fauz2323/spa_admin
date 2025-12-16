import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/models/list_voucher_network.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;

class VoucherNetwork {
  Future<Either<NetworkModel, ListVouchersModel>> getVouchers(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('https://rumah.nurfauzan.site/api/admin/vouchers'),
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
      final listVouchersModel = ListVouchersModel.fromJson(jsonData);
      return Right(listVouchersModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch vouchers',
      ),
    );
  }
}
