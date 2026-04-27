import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/dto/qr_scan_dto.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/models/user.dart';

class ChooseUserScreen extends StatefulWidget {
  final Function(User)? onUserSelected;

  const ChooseUserScreen({super.key, this.onUserSelected});

  @override
  State<ChooseUserScreen> createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Example list - replace with data from your Cubit/API
  List<User> _allUsers = [
    User(
      id: "1",
      name: "Budi Santoso",
      email: "user1@gg.com",
      phone: "08123456789",
      createdAt: DateTime.now().subtract(const Duration(days: 13)),
    ),
    User(
      id: "2",
      name: "Siti Aminah",
      email: "user1@gg.com",
      phone: "08998765432",
      createdAt: DateTime.now().subtract(const Duration(days: 23)),
    ),
  ];

  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredUsers = _allUsers
          .where(
            (user) => user.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih User'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. Search Bar & Action Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.withOpacity(0.05),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari Nama User...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Offline User Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          const jsonString = '''
                          {
                            "id": 18,
                            "name": "OFFLINE_USER",
                            "email": "offline_user@gg.com",
                            "phone": "08220010011",
                            "role": "customer",
                            "created_at": "2026-04-21T13:08:24.000000Z"
                          }
                          ''';
                          final offlineUser = User.fromJson(
                            jsonDecode(jsonString),
                          );
                          widget.onUserSelected?.call(offlineUser);
                          context.pop();
                        },
                        icon: const Icon(Icons.cloud_off),
                        label: const Text('User Offline'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // QR Scan Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                            AppRoutes.qrScan,
                            extra: QRScanDto(
                              successScanCallback: ({result}) {
                                // Logic to handle the scanned user ID/Data
                                if (result != null) {
                                  final user = User.fromJson(
                                    jsonDecode(result),
                                  );
                                  widget.onUserSelected?.call(user);
                                  context.pop();
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scan QR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. User List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.name),
                  subtitle: Text(user.phone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    widget.onUserSelected?.call(user);
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
