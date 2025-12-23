import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/list_voucher_network.dart';
import 'package:spa_admin/network/voucher_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'voucers_state.dart';
part 'voucers_cubit.freezed.dart';

class VoucersCubit extends Cubit<VoucersState> {
  VoucersCubit() : super(const VoucersState.initial());
  late String token;
  late ListVouchersModel vouchers;

  Future<void> initial() async {
    emit(const VoucersState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      print('VoucersCubit Token: $token');
      final req = await VoucherNetwork().getVouchers(token);
      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const VoucersState.unauthorized());
          } else {
            emit(VoucersState.error(l.message));
          }
        },
        (r) {
          emit(VoucersState.loaded(r));
        },
      );
    } catch (e) {
      emit(VoucersState.error(e.toString()));
    }
  }

  Future<String> delete(String id) async {
    emit(const VoucersState.loading());
    try {
      final req = await VoucherNetwork().deleteVoucher(token, id);
      await initial();
      return req.message;
    } catch (e) {
      emit(VoucersState.error(e.toString()));
      return e.toString();
    }
  }
}
