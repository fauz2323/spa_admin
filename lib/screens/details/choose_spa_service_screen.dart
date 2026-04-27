import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

import '../../models/service_model.dart';
import 'cubit/choose_spa_service_cubit.dart';

class ChooseSpaServiceScreen extends StatefulWidget {
  const ChooseSpaServiceScreen({
    super.key,
    this.backCallback,
  });

  final Function(Service? service)? backCallback;

  @override
  State<ChooseSpaServiceScreen> createState() => _ChooseSpaServiceScreenState();
}

class _ChooseSpaServiceScreenState extends State<ChooseSpaServiceScreen> {
  bool _isActive = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseSpaServiceCubit()..initial(),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow the pop to happen
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.backCallback?.call(null);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pilih Spa Service'),
          elevation: 0,
        ),
        body: BlocConsumer<ChooseSpaServiceCubit, ChooseSpaServiceState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              loaded: (data) {
              },
              success: () {
              },
              failure: (errorMessage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat service: $errorMessage'),
                  ),
                );
              },
              unauthorized: () async {
                await TokenUtils.deleteAllTokens();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unauthorized. Silakan login kembali.'),
                  ),
                );
                if (!mounted) return;
                context.go(AppRoutes.login);
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => _loaded(context, List.empty()),
              loaded: (data) => _loaded(context, data.data.services),
              loading: () => _loaded(context, List.empty()),
            );
          },
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, List<Service> services) {
    if (services.isEmpty) {
      return const Center(
        child: Text('Tidak ada layanan tersedia.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final service = services[index];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Service Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.spa, color: Colors.grey),
                        ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Name and Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${service.price?.toString() ?? '0'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Action Choose
                ElevatedButton(
                  onPressed: () {
                    // Send selected service back via callback
                    widget.backCallback?.call(service);
                    // Return to previous screen
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Pilih'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
