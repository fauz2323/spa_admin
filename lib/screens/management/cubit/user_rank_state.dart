part of 'user_rank_cubit.dart';

@freezed
class UserRankState with _$UserRankState {
  const factory UserRankState.initial() = _Initial;
  const factory UserRankState.loading() = _Loading;
  const factory UserRankState.loaded(UsersPointsModel data) = _Loaded;
  const factory UserRankState.error(String message) = _Error;
  const factory UserRankState.unauthorized() = _Unauthorized;
}
