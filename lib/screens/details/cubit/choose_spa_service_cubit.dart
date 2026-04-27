import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/network/service_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

import '../../../models/service_model.dart';

part 'choose_spa_service_cubit.freezed.dart';
part 'choose_spa_service_state.dart';

class ChooseSpaServiceCubit extends Cubit<ChooseSpaServiceState> {
  ChooseSpaServiceCubit() : super(const ChooseSpaServiceState.initial());
  late String token;

  initial() async {
    emit(const ChooseSpaServiceState.loading());

    token = await TokenUtils.getToken() ?? '';
    final req = await ServiceManagementNetwork().getSpaService(token);
    req.fold(
      (l) {
        if (l.statusCode == 401) {
          emit(const ChooseSpaServiceState.unauthorized());
        }
        emit(ChooseSpaServiceState.failure(l.message));
      },
      (r) {
        emit(ChooseSpaServiceState.loaded(r));
      },
    );
  }
}
