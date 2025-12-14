import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_admin/models/user_detail_model.dart';
import 'package:spa_admin/screens/details/cubit/user_detail_cubit.dart';
import 'package:spa_admin/utils/tokien_utils.dart';
import '../../models/user.dart';
import '../../models/reward_point.dart';

class UserDetailScreen extends StatefulWidget {
  final String email;

  const UserDetailScreen({super.key, required this.email});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RewardPoint> userRewardHistory = [];
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    print('UserDetailScreen initialized with email: ${widget.email}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailCubit()..initial(widget.email),
      child: Builder(
        builder: (context) {
          return _build(context);
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocConsumer<UserDetailCubit, UserDetailState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            unauthorized: () async {
              await TokenUtils.deleteAllTokens();

              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (userDetail) => _loaded(context, userDetail),
            error: (message) => Center(
              child: Text(
                'Error: $message',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            unauthorized: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, UserDetailModel data) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildUserHeader(data.data.name),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Orders'),
                Tab(text: 'Rewards'),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(data.data),
          _buildOrdersTab(),
          _buildRewardsTab(),
        ],
      ),
    );
  }

  Widget _buildUserHeader(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Data user) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Member Since',
                    _formatDate(user.createdAt),
                    Colors.purple,
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Personal Information
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.person, 'Full Name', user.name),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.email, 'Email', user.email),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone, 'Phone', user.phone),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Join Date',
                      _formatDate(user.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.star,
                      'Reward Points',
                      '${user.point.points} points',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 13,
        itemBuilder: (context, index) {
          return _buildOrderCard();
        },
      ),
    );
  }

  Widget _buildRewardsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: userRewardHistory.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No reward history found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userRewardHistory.length,
              itemBuilder: (context, index) {
                final reward = userRewardHistory[index];
                return _buildRewardCard(reward);
              },
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderCard() {
    Color statusColor = _getStatusColor('completed');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order #17',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Service Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(DateTime.now()),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                Text(
                  'Rp ${_formatCurrency(100000)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(RewardPoint reward) {
    final isEarned = reward.type == 'earned';
    final color = isEarned ? Colors.green : Colors.red;
    final icon = isEarned ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 20,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reward.reason,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${isEarned ? '+' : ''}${reward.points} pts',
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(reward.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'booked':
        return Colors.blue;
      case 'inProgress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
