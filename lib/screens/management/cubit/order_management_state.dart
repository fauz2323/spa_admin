part of 'order_management_cubit.dart';

@freezed
class OrderManagementState with _$OrderManagementState {
  const factory OrderManagementState.initial() = _Initial;
  const factory OrderManagementState.loading() = _Loading;
  const factory OrderManagementState.loaded(PendingOrdersModel data) = _Loaded;
  const factory OrderManagementState.error(String message) = _Error;
  const factory OrderManagementState.unauthorized() = _Unauthorized;
}
