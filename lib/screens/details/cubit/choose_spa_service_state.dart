part of 'choose_spa_service_cubit.dart';

@freezed
class ChooseSpaServiceState with _$ChooseSpaServiceState {
  const factory ChooseSpaServiceState.initial() = _Initial;
  const factory ChooseSpaServiceState.loading() = _Loading;
  const factory ChooseSpaServiceState.loaded(SpaServiceModel data) = _Loaded;
  const factory ChooseSpaServiceState.success() = _Success;
  const factory ChooseSpaServiceState.failure(String errorMessage) = _Failure;
  const factory ChooseSpaServiceState.unauthorized() = _Unauthorized;
}
