import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/user_detail_model.dart';
import 'package:spa_admin/network/users_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'user_detail_state.dart';
part 'user_detail_cubit.freezed.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  UserDetailCubit() : super(const UserDetailState.initial());
  late String token;

  initial(String email) async {
    emit(const UserDetailState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';

      final userDetail = await UsersManagementNetwork().userDetail(
        token,
        email,
      );

      userDetail.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const UserDetailState.unauthorized());
          } else {
            emit(UserDetailState.error(l.message));
          }
        },
        (r) {
          emit(UserDetailState.loaded(r));
        },
      );
    } catch (e) {
      emit(UserDetailState.error(e.toString()));
    }
  }
}
