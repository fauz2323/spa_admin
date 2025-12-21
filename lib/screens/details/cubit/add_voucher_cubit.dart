import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/dto/create_voucher_dto.dart';
import 'package:spa_admin/models/add_voucher_model.dart';
import 'package:spa_admin/network/voucher_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'add_voucher_state.dart';
part 'add_voucher_cubit.freezed.dart';

class AddVoucherCubit extends Cubit<AddVoucherState> {
  AddVoucherCubit() : super(const AddVoucherState.initial());
  late String token;

  save(CreateVoucherDto data) async {
    emit(const AddVoucherState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      final request = await VoucherNetwork().create(token, data);

      request.fold(
        (l) => emit(AddVoucherState.failure(l.message)),
        (r) => emit(AddVoucherState.success(r)),
      );
    } catch (e) {
      emit(AddVoucherState.failure(e.toString()));
    }
  }
}
