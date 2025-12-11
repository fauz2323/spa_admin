import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/dto/login_dto.dart';
import 'package:spa_admin/models/login_model.dart';
import 'package:spa_admin/network/auth_network.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial());
  final AuthNetwork _authNetwork = AuthNetwork();

  Future<String> login(String email, String password) async {
    emit(const LoginState.loading());
    try {
      final req = await _authNetwork.loginUser(
        LoginDto(email: email, password: password),
      );
      return req.fold<String>(
        (l) {
          emit(const LoginState.initial());
          return 'Login failed: ${l.message}';
        },
        (r) {
          emit(LoginState.loaded(r));
          return 'Login successful';
        },
      );
    } catch (e) {
      emit(LoginState.error(e.toString()));
      return 'An error occurred: ${e.toString()}';
    }
  }
}
