class DashboardStats {
  final int totalUsers;
  final int dailyOrders;
  final int pendingOrders;
  final int completedOrders;
  final double totalRevenue;
  final double todayRevenue;

  DashboardStats({
    required this.totalUsers,
    required this.dailyOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.totalRevenue,
    required this.todayRevenue,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['total_users'] ?? 0,
      dailyOrders: json['daily_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      todayRevenue: (json['today_revenue'] ?? 0).toDouble(),
    );
  }
}
