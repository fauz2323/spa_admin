import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/models/order_detail_model.dart';
import 'package:spa_admin/screens/details/cubit/order_detail_cubit.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final bool _isLoading = false;

  // Mock order detail data
  @override
  void initState() {
    super.initState();
  }

  // Simulate API call
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailCubit()..initial(widget.orderId),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  @override
  Widget _build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'Order ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OrderDetailCubit>().initial(widget.orderId);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<OrderDetailCubit>().initial(widget.orderId);
        },
        child: BlocConsumer<OrderDetailCubit, OrderDetailState>(
          listener: (context, state) {
            state.maybeWhen(
              unauthorized: () async {
                await TokenUtils.deleteAllTokens();
                // Handle unauthorized state, e.g., navigate to login
                if (!mounted) return;
                context.go('/login');
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('Initializing...')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (orderDetail) => _loaded(context, orderDetail),
              error: (message) => Center(
                child: Text(
                  'Error: $message',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              unauthorized: () => const Center(
                child: Text(
                  'Unauthorized. Redirecting to login...',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, OrderDetailModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            data.data.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(
                              data.data.status,
                            ).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          data.data.status,
                          style: TextStyle(
                            color: _getStatusColor(data.data.status),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Customer Information
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
                    'Customer Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.data.user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data.data.user.phone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigate to user detail
                          context.push('/user-detail');
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Service Details
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
                    'Service Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.data.spaService.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Booking Details
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
                    'Booking Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Booking Date',
                    data.data.dateService,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.access_time,
                    'Order Created',
                    _formatDateTime(data.data.createdAt),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.attach_money,
                    'Total Amount',
                    'Rp ${_formatCurrency(double.parse(data.data.spaService.price))}',
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Special Notes: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      data.data.notes,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
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
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Service'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Complete Service'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Order'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
