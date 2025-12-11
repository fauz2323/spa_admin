import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/users_points_model.dart';
import 'package:spa_admin/network/users_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'user_rank_state.dart';
part 'user_rank_cubit.freezed.dart';

class UserRankCubit extends Cubit<UserRankState> {
  UserRankCubit() : super(const UserRankState.initial());
  late String _token;

  initial() async {
    emit(const UserRankState.loading());
    try {
      _token = await TokenUtils.getToken() ?? '';
      final req = await UsersManagementNetwork().usersPoints(_token);
      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const UserRankState.unauthorized());
          } else {
            emit(UserRankState.error(l.message));
          }
        },
        (r) {
          emit(UserRankState.loaded(r));
        },
      );
    } catch (e) {
      emit(UserRankState.error(e.toString()));
    }
  }
}
