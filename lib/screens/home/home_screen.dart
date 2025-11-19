import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/routes.dart';
import '../../models/dashboard_stats.dart';
import '../../models/order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data
  final DashboardStats stats = DashboardStats(
    totalUsers: 1245,
    dailyOrders: 23,
    pendingOrders: 8,
    completedOrders: 157,
    totalRevenue: 125000.0,
    todayRevenue: 3450.0,
  );

  final List<Order> pendingOrders = [
    Order(
      id: '001',
      userId: 'user001',
      userName: 'Sarah Johnson',
      userPhone: '+62812345678',
      serviceName: 'Full Body Massage',
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      totalAmount: 350000,
      notes: 'First time customer',
      services: ['Full Body Massage', 'Aromatherapy'],
    ),
    Order(
      id: '002',
      userId: 'user002',
      userName: 'Maria Silva',
      userPhone: '+62823456789',
      serviceName: 'Facial Treatment',
      bookingDate: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      totalAmount: 250000,
      notes: 'Sensitive skin',
      services: ['Facial Treatment', 'Face Mask'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SPA Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(AppRoutes.profile);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back, Admin!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Here\'s what\'s happening at your spa today',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Cards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: [
                  _buildStatCard(
                    'Total Users',
                    stats.totalUsers.toString(),
                    Icons.people,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Daily Orders',
                    stats.dailyOrders.toString(),
                    Icons.shopping_cart,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Pending Orders',
                    stats.pendingOrders.toString(),
                    Icons.pending_actions,
                    Colors.red,
                  ),
                  _buildStatCard(
                    'Completed Orders',
                    stats.completedOrders.toString(),
                    Icons.check_circle,
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Revenue Cards
              Row(
                children: [
                  Expanded(
                    child: _buildRevenueCard(
                      'Today Revenue',
                      'Rp ${_formatCurrency(stats.todayRevenue)}',
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRevenueCard(
                      'Total Revenue',
                      'Rp ${_formatCurrency(stats.totalRevenue)}',
                      Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pending Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pending Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.orderManagement);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pending Orders List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingOrders.length,
                itemBuilder: (context, index) {
                  final order = pendingOrders[index];
                  return _buildOrderCard(order);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade900),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.spa, size: 30, color: Colors.blue),
                ),
                SizedBox(height: 12),
                Text(
                  'SPA Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.dashboard,
                  'Dashboard',
                  () => context.go(AppRoutes.home),
                ),
                _buildDrawerItem(
                  Icons.assignment,
                  'Order Management',
                  () => context.push(AppRoutes.orderManagement),
                ),
                _buildDrawerItem(
                  Icons.people_alt,
                  'User Management',
                  () => context.push(AppRoutes.userManagement),
                ),
                _buildDrawerItem(
                  Icons.card_giftcard,
                  'Reward Management',
                  () => context.push(AppRoutes.rewardManagement),
                ),
                _buildDrawerItem(
                  Icons.leaderboard,
                  'User Ranking',
                  () => context.push(AppRoutes.userRanking),
                ),
                const Divider(),
                _buildDrawerItem(
                  Icons.person,
                  'Profile',
                  () => context.push(AppRoutes.profile),
                ),
                _buildDrawerItem(
                  Icons.settings,
                  'Account Info',
                  () => context.push(AppRoutes.accountInfo),
                ),
                _buildDrawerItem(
                  Icons.logout,
                  'Logout',
                  () => context.go(AppRoutes.login),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(Icons.spa, color: Colors.orange.shade700),
        ),
        title: Text(
          order.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.serviceName),
            Text(
              'Rp ${_formatCurrency(order.totalAmount)}',
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            order.statusText,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
        onTap: () {
          context.push('${AppRoutes.orderDetail}/${order.id}');
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
