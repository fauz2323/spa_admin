import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spa_admin/dto/create_voucher_dto.dart';
import 'package:spa_admin/models/list_voucher_network.dart';
import 'package:spa_admin/screens/management/cubit/voucers_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

class VoucherManagementScreen extends StatelessWidget {
  const VoucherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoucersCubit()..initial(),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add voucher action
              context.push('/add-voucher');
            },
          ),
        ],
      ),
      body: BlocConsumer<VoucersCubit, VoucersState>(
        listener: (context, state) {
          state.whenOrNull(
            unauthorized: () async {
              await TokenUtils.deleteAllTokens();
              context.go('/login');
              // Handle unauthorized state, e.g., navigate to login
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Initializing...')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (data) => _loaded(context, data),
            error: (message) => Center(child: Text('Error: $message')),
            unauthorized: () => const Center(child: Text('Unauthorized')),
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, ListVouchersModel data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.data.length,
      itemBuilder: (context, index) {
        final voucher = data.data[index];
        return _buildVoucherCard(context, voucher);
      },
    );
  }

  Widget _buildVoucherCard(BuildContext context, Datum voucher) {
    final expiryDate = DateTime.parse(voucher.expiryDate.toString());
    final createdAt = DateTime.parse(voucher.createdAt.toString());
    final dateFormat = DateFormat('dd MMM yyyy');
    final dateTimeFormat = DateFormat('dd MMM yyyy HH:mm');

    final isExpired = expiryDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    voucher.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isExpired ? 'Expired' : 'Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.attach_money,
              'Price',
              '${_formatCurrency(voucher.price.toString())} Points',
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.discount,
              'Discount Amount',
              'Rp ${_formatCurrency(voucher.discountAmount.toString())}',
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today,
              'Expiry Date',
              dateFormat.format(expiryDate),
              isExpired ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.access_time,
              'Created At',
              dateTimeFormat.format(createdAt),
              Colors.grey,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.push(
                      AppRoutes.addVoucher,
                      extra: CreateVoucherDto(
                        id: voucher.id,
                        name: voucher.name,
                        price: voucher.price,
                        discountAmount: voucher.discountAmount.toDouble(),
                        expiryDate: voucher.expiryDate,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete ${voucher.name}')),
                    );
                  },
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(String amount) {
    final number = double.tryParse(amount.replaceAll(',', '')) ?? 0;
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number);
  }
}
