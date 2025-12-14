import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/dto/create_service_dto.dart';
import 'package:spa_admin/network/service_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'add_spa_service_state.dart';
part 'add_spa_service_cubit.freezed.dart';

class AddSpaServiceCubit extends Cubit<AddSpaServiceState> {
  AddSpaServiceCubit() : super(const AddSpaServiceState.initial());
  late String token;

  createData(CreateServiceDto data) async {
    emit(const AddSpaServiceState.loading());
    // try {
    token = await TokenUtils.getToken() ?? '';
    if (token.isEmpty) {
      emit(const AddSpaServiceState.unauthorized());
      return;
    }
    final req = await ServiceManagementNetwork().create(token, data);
    req.fold(
      (l) {
        if (l.statusCode == 401) {
          emit(const AddSpaServiceState.unauthorized());
        }
        emit(AddSpaServiceState.failure(l.message));
      },
      (r) {
        emit(const AddSpaServiceState.success());
      },
    );
    // } catch (e) {
    //   // On failure
    //   emit(AddSpaServiceState.failure(e.toString()));
    // }
  }
}
