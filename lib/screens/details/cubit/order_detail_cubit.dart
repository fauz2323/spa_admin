import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/order_detail_model.dart';
import 'package:spa_admin/network/order_management_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'order_detail_state.dart';
part 'order_detail_cubit.freezed.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(const OrderDetailState.initial());
  late String token;

  initial(String id) async {
    emit(const OrderDetailState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';

      final orderDetail = await OrderManagementNetwork().orderDetail(token, id);

      orderDetail.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const OrderDetailState.unauthorized());
          } else {
            emit(OrderDetailState.error(l.message));
          }
        },
        (r) {
          emit(OrderDetailState.loaded(r));
        },
      );
    } catch (e) {
      emit(OrderDetailState.error(e.toString()));
    }
  }

  changeStatus(String id, String status) async {
    emit(const OrderDetailState.loading());
    try {
      final changeStatus = await OrderManagementNetwork().changeStatus(
        token,
        id,
        status,
      );

      changeStatus.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const OrderDetailState.unauthorized());
          } else {
            emit(OrderDetailState.error(l.message));
          }
        },
        (r) {
          initial(id);
        },
      );
    } catch (e) {
      emit(OrderDetailState.error(e.toString()));
    }
  }
}
