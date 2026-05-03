import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/dto/qr_scan_dto.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/models/user.dart';

import '../../network/users_management_network.dart';
import '../../utils/tokien_utils.dart';

class ChooseUserScreen extends StatefulWidget {
  final Function(User)? onUserSelected;

  const ChooseUserScreen({super.key, this.onUserSelected});

  @override
  State<ChooseUserScreen> createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  final TextEditingController _searchController = TextEditingController();

  final UsersManagementNetwork _usersManagementNetwork =
      UsersManagementNetwork();

  // Example list - replace with data from your Cubit/API
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  String token = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchToken();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchToken() async {
    token = await TokenUtils.getToken() ?? '';
    await searchUser();
  }

  void _onSearchChanged() async {
    // 3. Cancel the timer if the user is still typing
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 4. Start a new timer for 2 seconds
    _debounce = Timer(const Duration(seconds: 2), () async {
      setState(() {
        _filteredUsers = _allUsers
            .where(
              (user) => user.name.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();
      });
    });
  }

  Future<void> searchUser({String keyword = ''}) async {
    final userListResponse = await _usersManagementNetwork.searchUser(
      token,
      keyword,
    );

    userListResponse.fold(
      (networkError) {
        // emit(BookingPageState.error(message: networkError.message));
      },
      (userListModel) {
        setState(() {
          _allUsers = userListModel.data;
          _filteredUsers = _allUsers;
        });
      },
    );
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
                          // const jsonString = '''
                          // {
                          //   "id": 18,
                          //   "name": "OFFLINE_USER",
                          //   "email": "offline_user@gg.com",
                          //   "phone": "08220010011",
                          //   "role": "customer",
                          //   "created_at": "2026-04-21T13:08:24.000000Z"
                          // }
                          // ''';
                          // final offlineUser = User.fromJson(
                          //   jsonDecode(jsonString),
                          // );
                          // widget.onUserSelected?.call(offlineUser);
                          // context.pop();

                          _showCreateOfflineUserDialog();
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
    _debounce?.cancel(); // 5. Always cancel the timer on dispose
    super.dispose();
  }

  void _showCreateOfflineUserDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Data User Offline'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'No. Telepon'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Telepon wajib diisi' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final result = await _usersManagementNetwork.createUser(
                  token,
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );

                if (mounted) {
                  Navigator.pop(context); // Close Loading

                  result.fold(
                    (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal: ${error.message}')),
                      );
                    },
                    (response) {
                      // Successfully created
                      widget.onUserSelected?.call(response.data.user);
                      Navigator.pop(context); // Close Dialog
                      context.pop(); // Return to Add Order screen
                    },
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
