import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/pending_orders_model.dart';
import 'package:spa_admin/network/home_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'order_management_state.dart';
part 'order_management_cubit.freezed.dart';

class OrderManagementCubit extends Cubit<OrderManagementState> {
  OrderManagementCubit() : super(const OrderManagementState.initial());
  late String token;

  initial() async {
    emit(const OrderManagementState.loading());
    try {
      token = await TokenUtils.getToken() ?? '';
      final req = await HomeNetwork().pendingOrders(token, 'all');

      req.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const OrderManagementState.unauthorized());
          } else {
            emit(OrderManagementState.error(l.message ?? 'Unknown error'));
          }
        },
        (r) {
          emit(OrderManagementState.loaded(r));
        },
      );
    } catch (e) {
      emit(OrderManagementState.error(e.toString()));
    }
  }
}
