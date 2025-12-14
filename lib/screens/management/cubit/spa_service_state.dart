part of 'spa_service_cubit.dart';

@freezed
class SpaServiceState with _$SpaServiceState {
  const factory SpaServiceState.initial() = _Initial;
  const factory SpaServiceState.loading() = _Loading;
  const factory SpaServiceState.loaded(SpaServiceModel services) = _Loaded;
  const factory SpaServiceState.error(String message) = _Error;
  const factory SpaServiceState.unauthorized() = _Unauthorized;
}
