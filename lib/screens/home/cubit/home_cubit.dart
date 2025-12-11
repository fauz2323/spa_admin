import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spa_admin/models/dashboard_model.dart';
import 'package:spa_admin/models/network_model.dart';
import 'package:spa_admin/models/pending_orders_model.dart';
import 'package:spa_admin/network/home_network.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial());
  late String token;

  initial() async {
    emit(const HomeState.loading());
    try {
      // Simulate data fetching
      token = await TokenUtils.getToken() ?? '';
      final req = await Future.wait([
        HomeNetwork().dashboard(token),
        HomeNetwork().pendingOrders(token, 'pending'),
      ]);

      final dashboard = req[0] as Either<NetworkModel, DashboardModel>;
      final pendingOrders = req[1] as Either<NetworkModel, PendingOrdersModel>;

      final result = dashboard.flatMap(
        (dataDashboard) => pendingOrders.map(
          (pendingOrdersData) => (a: dataDashboard, b: pendingOrdersData),
        ),
      );

      result.fold(
        (l) {
          if (l.statusCode == 401) {
            emit(const HomeState.unauthorized());
          } else {
            emit(HomeState.error(l.message ?? 'Unknown error'));
          }
        },
        (r) {
          emit(HomeState.loaded(r.a, r.b));
        },
      );

      // final req = await HomeNetwork().dashboard(token);
      // return req.fold(
      //   (l) {
      //     if (l.statusCode == 401) {
      //       emit(const HomeState.unauthorized());
      //     } else {
      //       emit(HomeState.error(l.message ?? 'Unknown error'));
      //     }
      //   },
      //   (r) {
      //     emit(HomeState.loaded(r));
      //   },
      // );
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }
}
