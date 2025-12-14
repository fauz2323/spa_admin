part of 'order_detail_cubit.dart';

@freezed
class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState.initial() = _Initial;
  const factory OrderDetailState.loading() = _Loading;
  const factory OrderDetailState.loaded(OrderDetailModel orderDetail) = _Loaded;
  const factory OrderDetailState.error(String message) = _Error;
  const factory OrderDetailState.unauthorized() = _Unauthorized;
}
