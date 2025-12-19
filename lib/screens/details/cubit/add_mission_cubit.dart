import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/dto/create_mission_dto.dart';
import 'package:spa_admin/models/mission_create_model.dart';
import 'package:spa_admin/network/mission_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'add_mission_state.dart';
part 'add_mission_cubit.freezed.dart';

class AddMissionCubit extends Cubit<AddMissionState> {
  AddMissionCubit() : super(const AddMissionState.initial());
  late String token;

  initial(String id) async {
    emit(const AddMissionState.loading());
    token = await TokenUtils.getToken() ?? '';
    // Simulate data fetching
    if (id == '0') {
      return emit(const AddMissionState.initial());
    }

    final req = await MissionNetwork().getMission(token, id);
    req.fold(
      (l) {
        if (l.statusCode == 401) {
          emit(const AddMissionState.unauthorized());
        }
        emit(AddMissionState.failure(l.message));
      },
      (r) {
        emit(AddMissionState.loaded(r));
      },
    );
  }

  Future submitMission(CreateMissionDto data) async {
    emit(const AddMissionState.loading());

    final req = await MissionNetwork().createMission(token, data);
    req.fold(
      (l) {
        if (l.statusCode == 401) {
          emit(const AddMissionState.unauthorized());
        }
        emit(AddMissionState.failure(l.message));
      },
      (r) {
        emit(AddMissionState.loaded(r));
      },
    );
  }
}
