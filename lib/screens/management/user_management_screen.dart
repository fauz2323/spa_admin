import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../utils/routes.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _sortBy = 'name'; // name, date, points
  bool _showActiveOnly = false;

  // Mock data
  final List<User> _allUsers = [
    User(
      id: 'user001',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@email.com',
      phone: '+62812345678',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      rewardPoints: 1250,
      isActive: true,
      profileImage: '',
    ),
    User(
      id: 'user002',
      name: 'Maria Silva',
      email: 'maria.silva@email.com',
      phone: '+62823456789',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      rewardPoints: 890,
      isActive: true,
      profileImage: '',
    ),
    User(
      id: 'user003',
      name: 'Jessica Brown',
      email: 'jessica.brown@email.com',
      phone: '+62834567890',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      rewardPoints: 2150,
      isActive: true,
      profileImage: '',
    ),
    User(
      id: 'user004',
      name: 'Emma Wilson',
      email: 'emma.wilson@email.com',
      phone: '+62845678901',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      rewardPoints: 450,
      isActive: false,
      profileImage: '',
    ),
    User(
      id: 'user005',
      name: 'Lisa Anderson',
      email: 'lisa.anderson@email.com',
      phone: '+62856789012',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      rewardPoints: 3200,
      isActive: true,
      profileImage: '',
    ),
    User(
      id: 'user006',
      name: 'Anna Davis',
      email: 'anna.davis@email.com',
      phone: '+62867890123',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      rewardPoints: 120,
      isActive: true,
      profileImage: '',
    ),
  ];

  List<User> _getFilteredAndSortedUsers() {
    List<User> filteredUsers = _allUsers;

    // Filter by active status
    if (_showActiveOnly) {
      filteredUsers = filteredUsers.where((user) => user.isActive).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.phone.contains(_searchQuery),
          )
          .toList();
    }

    // Sort users
    switch (_sortBy) {
      case 'name':
        filteredUsers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'date':
        filteredUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'points':
        filteredUsers.sort((a, b) => b.rewardPoints.compareTo(a.rewardPoints));
        break;
    }

    return filteredUsers;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredAndSortedUsers();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Users',
                        _allUsers.length.toString(),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Active Users',
                        _allUsers.where((u) => u.isActive).length.toString(),
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'New This Month',
                        _allUsers
                            .where(
                              (u) => u.createdAt.isAfter(
                                DateTime.now().subtract(
                                  const Duration(days: 30),
                                ),
                              ),
                            )
                            .length
                            .toString(),
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Simulate refresh
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {});
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _buildUserCard(user);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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

  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.push('${AppRoutes.userDetail}/${user.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Picture
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 25,
                child: Icon(
                  Icons.person,
                  color: Colors.blue.shade900,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: user.isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: user.isActive
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: user.isActive ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Phone
                    Text(
                      user.phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Points and Join Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user.rewardPoints} pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Joined ${_formatDate(user.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Filter & Sort'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort by:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    title: const Text('Name'),
                    value: 'name',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setStateDialog(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Join Date'),
                    value: 'date',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setStateDialog(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Reward Points'),
                    value: 'points',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setStateDialog(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Show Active Users Only'),
                    value: _showActiveOnly,
                    onChanged: (value) {
                      setStateDialog(() {
                        _showActiveOnly = value ?? false;
                      });
                    },
                  ),
                ],
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
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
