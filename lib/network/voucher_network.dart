import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_admin/dto/create_voucher_dto.dart';
import 'package:spa_admin/models/add_voucher_model.dart';
import 'package:spa_admin/models/list_voucher_network.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:http/http.dart' as http;

class VoucherNetwork {
  Future<Either<NetworkModel, ListVouchersModel>> getVouchers(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('https://rizky-firman.com/api/admin/vouchers'),
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

  Future<Either<NetworkModel, AddVoucherModel>> create(
    String token,
    CreateVoucherDto data,
  ) async {
    late Uri uri;
    late Map body;

    if (data.id != null && data.id != 0) {
      uri = Uri.parse('https://rizky-firman.com/api/admin/vouchers/edit');
      body = {
        'id': data.id.toString(),
        'name': data.name,
        'price': data.price.toString(),
        'discount_amount': data.discountAmount.toString(),
        'expiry_date': data.expiryDate.toIso8601String().split('T')[0],
      };
    } else {
      uri = Uri.parse('https://rizky-firman.com/api/admin/vouchers/create');
      body = {
        'name': data.name,
        'price': data.price.toString(),
        'discount_amount': data.discountAmount.toString(),
        'expiry_date': data.expiryDate.toIso8601String().split('T')[0],
      };
    }

    final response = await http.post(
      uri,
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
      final addVoucherModel = AddVoucherModel.fromJson(jsonData);
      return Right(addVoucherModel);
    }
    return Left(
      NetworkModel(
        statusCode: response.statusCode,
        message: jsonData['message'] ?? 'Failed to fetch vouchers',
      ),
    );
  }
}
