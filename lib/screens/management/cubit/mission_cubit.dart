import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/list_mission_model.dart';
import 'package:spa_admin/network/mission_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'mission_state.dart';
part 'mission_cubit.freezed.dart';

class MissionCubit extends Cubit<MissionState> {
  MissionCubit() : super(const MissionState.initial());

  late String token;

  initial() async {
    emit(const MissionState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      print('MissionCubit Token: $token');
      final req = await MissionNetwork().getMissions(token);

      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const MissionState.unauthorized());
          } else {
            emit(MissionState.error(l.message));
          }
        },
        (r) {
          emit(MissionState.loaded(r));
        },
      );
    } catch (e) {
      emit(MissionState.error(e.toString()));
    }
  }
}
