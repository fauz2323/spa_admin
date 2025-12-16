part of 'mission_cubit.dart';

@freezed
class MissionState with _$MissionState {
  const factory MissionState.initial() = _Initial;
  const factory MissionState.loading() = _Loading;
  const factory MissionState.loaded(ListMissionModel missions) = _Loaded;
  const factory MissionState.error(String message) = _Error;
  const factory MissionState.unauthorized() = _Unauthorized;
}
