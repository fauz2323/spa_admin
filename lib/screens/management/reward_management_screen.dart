import 'package:flutter/material.dart';
import '../../models/reward_point.dart';

class RewardManagementScreen extends StatefulWidget {
  const RewardManagementScreen({super.key});

  @override
  State<RewardManagementScreen> createState() => _RewardManagementScreenState();
}

class _RewardManagementScreenState extends State<RewardManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  // Mock data
  final List<RewardPoint> _allRewardPoints = [
    RewardPoint(
      id: 'rp001',
      userId: 'user001',
      userName: 'Sarah Johnson',
      points: 150,
      reason: 'Full Body Massage booking',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'earned',
    ),
    RewardPoint(
      id: 'rp002',
      userId: 'user002',
      userName: 'Maria Silva',
      points: -100,
      reason: 'Discount redemption',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'redeemed',
    ),
    RewardPoint(
      id: 'rp003',
      userId: 'user003',
      userName: 'Jessica Brown',
      points: 200,
      reason: 'Hot Stone Therapy booking',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: 'earned',
    ),
    RewardPoint(
      id: 'rp004',
      userId: 'user001',
      userName: 'Sarah Johnson',
      points: -50,
      reason: 'Free service redemption',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: 'redeemed',
    ),
    RewardPoint(
      id: 'rp005',
      userId: 'user005',
      userName: 'Lisa Anderson',
      points: 300,
      reason: 'Couple Massage booking',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      type: 'earned',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RewardPoint> _getFilteredRewardPoints(String? type) {
    List<RewardPoint> filteredPoints = _allRewardPoints;

    if (type != null) {
      filteredPoints = _allRewardPoints
          .where((point) => point.type == type)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredPoints = filteredPoints
          .where(
            (point) =>
                point.userName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                point.reason.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filteredPoints..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'Reward Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Transactions'),
            Tab(text: 'Points Earned'),
            Tab(text: 'Points Redeemed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPointsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats and Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Earned',
                        _getTotalEarned().toString(),
                        Colors.green,
                        Icons.add_circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Redeemed',
                        _getTotalRedeemed().toString(),
                        Colors.red,
                        Icons.remove_circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Net Points',
                        (_getTotalEarned() + _getTotalRedeemed()).toString(),
                        Colors.blue,
                        Icons.account_balance,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search reward transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),

          // Reward Points List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRewardPointsList(_getFilteredRewardPoints(null)),
                _buildRewardPointsList(_getFilteredRewardPoints('earned')),
                _buildRewardPointsList(_getFilteredRewardPoints('redeemed')),
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPointsList(List<RewardPoint> rewardPoints) {
    if (rewardPoints.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reward transactions found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rewardPoints.length,
        itemBuilder: (context, index) {
          final rewardPoint = rewardPoints[index];
          return _buildRewardPointCard(rewardPoint);
        },
      ),
    );
  }

  Widget _buildRewardPointCard(RewardPoint rewardPoint) {
    final isEarned = rewardPoint.type == 'earned';
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
            // Icon
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name and points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rewardPoint.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${isEarned ? '+' : ''}${rewardPoint.points} pts',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Reason
                  Text(
                    rewardPoint.reason,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),

                  // Date and type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDateTime(rewardPoint.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isEarned
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEarned ? 'Earned' : 'Redeemed',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPointsDialog() {
    final TextEditingController userController = TextEditingController();
    final TextEditingController pointsController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();
    String selectedType = 'earned';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add Reward Points'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Points',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Earned'),
                            value: 'earned',
                            groupValue: selectedType,
                            onChanged: (value) {
                              setStateDialog(() {
                                selectedType = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Redeemed'),
                            value: 'redeemed',
                            groupValue: selectedType,
                            onChanged: (value) {
                              setStateDialog(() {
                                selectedType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add the reward point (mock implementation)
                    if (userController.text.isNotEmpty &&
                        pointsController.text.isNotEmpty &&
                        reasonController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reward points added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int _getTotalEarned() {
    return _allRewardPoints
        .where((point) => point.type == 'earned')
        .fold(0, (sum, point) => sum + point.points);
  }

  int _getTotalRedeemed() {
    return _allRewardPoints
        .where((point) => point.type == 'redeemed')
        .fold(0, (sum, point) => sum + point.points);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
