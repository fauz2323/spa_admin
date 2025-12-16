part of 'voucers_cubit.dart';

@freezed
class VoucersState with _$VoucersState {
  const factory VoucersState.initial() = _Initial;
  const factory VoucersState.loading() = _Loading;
  const factory VoucersState.loaded(ListVouchersModel data) = _Loaded;
  const factory VoucersState.error(String message) = _Error;
  const factory VoucersState.unauthorized() = _Unauthorized;
}
