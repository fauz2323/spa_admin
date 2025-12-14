part of 'add_spa_service_cubit.dart';

@freezed
class AddSpaServiceState with _$AddSpaServiceState {
  const factory AddSpaServiceState.initial() = _Initial;
  const factory AddSpaServiceState.loading() = _Loading;
  const factory AddSpaServiceState.loaded(ServiceDetailModel data) = _Loaded;
  const factory AddSpaServiceState.success() = _Success;
  const factory AddSpaServiceState.failure(String errorMessage) = _Failure;
  const factory AddSpaServiceState.unauthorized() = _Unauthorized;
}
