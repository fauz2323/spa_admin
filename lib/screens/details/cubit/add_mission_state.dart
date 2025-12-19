part of 'add_mission_cubit.dart';

@freezed
class AddMissionState with _$AddMissionState {
  const factory AddMissionState.initial() = _Initial;
  const factory AddMissionState.loading() = _Loading;
  const factory AddMissionState.loaded(MissionCreateModel data) = _Success;
  const factory AddMissionState.failure(String errorMessage) = _Failure;
  const factory AddMissionState.unauthorized() = _Unauthorized;
}
