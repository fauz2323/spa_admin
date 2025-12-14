import 'package:go_router/go_router.dart';
import 'package:spa_admin/screens/details/add_spa_service_screen.dart';
import 'package:spa_admin/screens/management/service_management_screen.dart';

// Screens
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/management/order_management_screen.dart';
import '../screens/management/user_management_screen.dart';
import '../screens/management/reward_management_screen.dart';
import '../screens/management/user_ranking_screen.dart';
import '../screens/details/order_detail_screen.dart';
import '../screens/details/user_detail_screen.dart';
import '../screens/home/account_info_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String orderManagement = '/order-management';
  static const String userManagement = '/user-management';
  static const String rewardManagement = '/reward-management';
  static const String userRanking = '/user-ranking';
  static const String orderDetail = '/order-detail';
  static const String userDetail = '/user-detail';
  static const String accountInfo = '/account-info';
  static const String serviceManagement = '/service-management';
  static const String addServiceSpa = '/add-service-spa';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderManagement,
      name: 'order-management',
      builder: (context, state) => const OrderManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.userManagement,
      name: 'user-management',
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.rewardManagement,
      name: 'reward-management',
      builder: (context, state) => const RewardManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.userRanking,
      name: 'user-ranking',
      builder: (context, state) => const UserRankingScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.orderDetail}/:orderId',
      name: 'order-detail',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderDetailScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: AppRoutes.userDetail,
      name: 'user-detail',
      builder: (context, state) {
        final email = state.extra as String;
        return UserDetailScreen(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.accountInfo,
      name: 'account-info',
      builder: (context, state) => const AccountInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.serviceManagement,
      name: 'service-management',
      builder: (context, state) => const ServiceManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.addServiceSpa,
      name: 'add-service-spa',
      builder: (context, state) {
        final id = state.extra ?? '0';
        return AddSpaServiceScreen(id: id as String);
      },
    ),
  ],
);
