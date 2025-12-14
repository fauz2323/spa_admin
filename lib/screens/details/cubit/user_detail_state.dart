part of 'user_detail_cubit.dart';

@freezed
class UserDetailState with _$UserDetailState {
  const factory UserDetailState.initial() = _Initial;
  const factory UserDetailState.loading() = _Loading;
  const factory UserDetailState.loaded(UserDetailModel userDetail) = _Loaded;
  const factory UserDetailState.error(String message) = _Error;
  const factory UserDetailState.unauthorized() = _Unauthorized;
}
