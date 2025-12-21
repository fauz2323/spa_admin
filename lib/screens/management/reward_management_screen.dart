import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_admin/models/history_points_model.dart';
import 'package:spa_admin/screens/management/cubit/reward_management_cubit.dart';
import 'package:spa_admin/utils/tokien_utils.dart';
import '../../models/reward_point.dart';

class RewardManagementScreen extends StatefulWidget {
  const RewardManagementScreen({super.key});

  @override
  State<RewardManagementScreen> createState() => _RewardManagementScreenState();
}

class _RewardManagementScreenState extends State<RewardManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  List<Datum> _getFilteredRewardPoints(String? type, HistoryPointModel? model) {
    List<Datum> filteredPoints = model?.data ?? [];

    if (type == 'earned') {
      filteredPoints = filteredPoints
          .where((point) => point.points > 0)
          .toList();
    } else if (type == 'redeemed') {
      filteredPoints = filteredPoints
          .where((point) => point.points < 0)
          .toList();
    }

    return filteredPoints..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardManagementCubit()..initial(),
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
      body: BlocConsumer<RewardManagementCubit, RewardManagementState>(
        listener: (context, state) {
          state.mapOrNull(
            unauthorized: (_) async {
              await TokenUtils.deleteAllTokens();
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const Center(child: CircularProgressIndicator());
            },
            loaded: (data) {
              return _loaded(context, data);
            },
            error: (message) {
              return Center(
                child: Text(message, style: const TextStyle(color: Colors.red)),
              );
            },
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, HistoryPointModel pointData) {
    return Column(
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
                      pointData.data
                          .where((point) => point.points > 0)
                          .fold<int>(0, (sum, point) => sum + point.points)
                          .toString(),
                      Colors.green,
                      Icons.add_circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Total Redeemed',
                      pointData.data
                          .where((point) => point.points < 0)
                          .fold<int>(
                            0,
                            (sum, point) => sum + point.points.abs(),
                          )
                          .toString(),
                      Colors.red,
                      Icons.remove_circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
            ],
          ),
        ),

        // Reward Points List
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRewardPointsList(_getFilteredRewardPoints(null, pointData)),
              _buildRewardPointsList(
                _getFilteredRewardPoints('earned', pointData),
              ),
              _buildRewardPointsList(
                _getFilteredRewardPoints('redeemed', pointData),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildRewardPointsList(List<Datum> rewardPoints) {
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

  Widget _buildRewardPointCard(Datum rewardPoint) {
    final isEarned = rewardPoint.points > 0;
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
                        rewardPoint.user.name,
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
                    rewardPoint.description,
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
