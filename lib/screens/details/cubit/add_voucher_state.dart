part of 'add_voucher_cubit.dart';

@freezed
class AddVoucherState with _$AddVoucherState {
  const factory AddVoucherState.initial() = _Initial;
  const factory AddVoucherState.loading() = _Loading;
  const factory AddVoucherState.success(AddVoucherModel data) = _Success;
  const factory AddVoucherState.failure(String errorMessage) = _Failure;
}
