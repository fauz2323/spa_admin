import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/history_model.dart';
import 'package:spa_admin/models/user_detail_model.dart';
import 'package:spa_admin/network/users_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

import '../../../models/detail_history_point_model.dart';

part 'user_detail_state.dart';

part 'user_detail_cubit.freezed.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  UserDetailCubit() : super(const UserDetailState.initial());
  late String token;
  HistoryModel? historyModel;
  DetailHistoryPointModel? historyPointModel;

  initial(String email) async {
    emit(const UserDetailState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      final userManagementNetwork = UsersManagementNetwork();
      final userDetail = await userManagementNetwork.userDetail(token, email);

      userDetail.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const UserDetailState.unauthorized());
          } else {
            emit(UserDetailState.error(l.message));
          }
        },
        (detailResponse) async {
          final historyOrderCall = await userManagementNetwork.historyOrder(
            token,
            detailResponse.data.id.toString(),
          );
          historyOrderCall.fold(
            (l) {
              if (l.statusCode == 401) {
                emit(const UserDetailState.unauthorized());
              } else {
                emit(UserDetailState.error(l.message));
              }
            },
            (r) {
              historyModel = r;
            },
          );

          final historyPointCall = await userManagementNetwork.historyPoint(
            token,
            detailResponse.data.id.toString(),
          );
          historyPointCall.fold(
            (l) {
              if (l.statusCode == 401) {
                emit(const UserDetailState.unauthorized());
              } else {
                emit(UserDetailState.error(l.message));
              }
            },
            (r) {
              historyPointModel = r;
            },
          );

          emit(UserDetailState.loaded(detailResponse));
        },
      );
    } catch (e) {
      emit(UserDetailState.error(e.toString()));
    }
  }
}
