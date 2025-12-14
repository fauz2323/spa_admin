import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/service_model.dart';
import 'package:spa_admin/network/service_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'spa_service_state.dart';
part 'spa_service_cubit.freezed.dart';

class SpaServiceCubit extends Cubit<SpaServiceState> {
  SpaServiceCubit() : super(const SpaServiceState.initial());
  late String token;

  initial() async {
    emit(const SpaServiceState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';

      final req = await ServiceManagementNetwork().getSpaService(token);

      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const SpaServiceState.unauthorized());
          } else {
            emit(SpaServiceState.error(l.message));
          }
        },
        (r) {
          emit(SpaServiceState.loaded(r));
        },
      );
    } catch (e) {
      emit(SpaServiceState.error(e.toString()));
    }
  }

  delete(String id) async {
    emit(const SpaServiceState.loading());
    try {
      final req = await ServiceManagementNetwork().deleteSpaService(token, id);

      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const SpaServiceState.unauthorized());
          } else {
            emit(SpaServiceState.error(l.message));
          }
        },
        (r) {
          initial();
        },
      );
    } catch (e) {
      emit(SpaServiceState.error(e.toString()));
    }
  }
}
