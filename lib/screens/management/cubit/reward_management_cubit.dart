import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/history_points_model.dart';
import 'package:spa_admin/network/point_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'reward_management_state.dart';
part 'reward_management_cubit.freezed.dart';

class RewardManagementCubit extends Cubit<RewardManagementState> {
  RewardManagementCubit() : super(const RewardManagementState.initial());
  late String token;

  initial() async {
    emit(const RewardManagementState.loading());

    token = await TokenUtils.getToken() ?? '';
    final request = await PointNetwork().getPoint(token);

    request.fold(
      (l) => emit(RewardManagementState.error(l.message)),
      (r) => emit(RewardManagementState.loaded(r)),
    );
  }
}
