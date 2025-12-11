import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/users_list_model.dart';
import 'package:spa_admin/network/users_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'user_management_state.dart';
part 'user_management_cubit.freezed.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit() : super(const UserManagementState.initial());
  late String token;

  initial() async {
    emit(const UserManagementState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      final req = await UsersManagementNetwork().usersList(token);

      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const UserManagementState.unauthorized());
          } else {
            emit(UserManagementState.error(l.message));
          }
        },
        (r) {
          emit(UserManagementState.loaded(r));
        },
      );
    } catch (e) {
      emit(UserManagementState.error(e.toString()));
    }
  }
}
