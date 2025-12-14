import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/screens/management/cubit/spa_service_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';
import '../../models/service_model.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpaServiceCubit()..initial(),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Service Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              context.push(AppRoutes.addServiceSpa);
            },
            tooltip: 'Add Service',
          ),
        ],
      ),
      body: BlocConsumer<SpaServiceCubit, SpaServiceState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthorized: () async {
              await TokenUtils.deleteAllTokens();
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $message')));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const Center(child: Text('Unknown state'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            unauthorized: () {
              return const Center(child: Text('Unauthorized. Redirecting...'));
            },
            error: (message) {
              return Center(child: Text('Error: $message'));
            },
            loaded: (data) {
              return _loaded(context, data);
            },
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, SpaServiceModel data) {
    return Column(
      children: [
        // Header with Search and Stats
        Container(
          color: AppConstants.surfaceColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Services',
                      data.data.services.length.toString(),
                      Icons.spa,
                      AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Active',
                      data.data.services
                          .where((s) => s.isActive)
                          .length
                          .toString(),
                      Icons.check_circle,
                      AppConstants.successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Services List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<SpaServiceCubit>().initial();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.data.services.length,
              itemBuilder: (context, index) {
                final service = data.data.services[index];
                return _buildServiceCard(context, service);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppConstants.dividerColor, width: 1),
      ),
      child: InkWell(
        onTap: () {
          _showServiceDetail(context, service);
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Container(
                  width: 100,
                  height: 100,
                  color: AppConstants.dividerColor,
                  child: Image.network(
                    service.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.spa,
                          size: 40,
                          color: AppConstants.primaryColor,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppConstants.backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Service Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Description
                    Text(
                      service.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Price and Points
                    Row(
                      children: [
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppConstants.successColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.attach_money,
                                size: 14,
                                color: AppConstants.successColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Rp ${AppFormats.formatCurrency(double.parse(service.price))}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.successColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Points
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.warningColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppConstants.warningColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars,
                                size: 14,
                                color: AppConstants.warningColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${service.points} pts',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.warningColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Column(
                children: [
                  StatusChip(
                    label: service.isActive ? 'Active' : 'Inactive',
                    color: service.isActive
                        ? AppConstants.successColor
                        : AppConstants.textHint,
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppConstants.textSecondary,
                    ),
                    onPressed: () {
                      _showServiceOptions(context, service);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDetail(BuildContext contextParent, Service service) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  topRight: Radius.circular(AppConstants.borderRadius),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: AppConstants.dividerColor,
                  child: Image.network(
                    service.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.spa,
                          size: 80,
                          color: AppConstants.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                        ),
                        StatusChip(
                          label: service.isActive ? 'Active' : 'Inactive',
                          color: service.isActive
                              ? AppConstants.successColor
                              : AppConstants.textHint,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      service.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppConstants.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Details
                    _buildDetailRow(
                      'Service ID',
                      service.id.toString(),
                      Icons.fingerprint,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Price',
                      'Rp ${AppFormats.formatCurrency(double.parse(service.price))}',
                      Icons.attach_money,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Reward Points',
                      '${service.points} points',
                      Icons.stars,
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                              side: const BorderSide(
                                color: AppConstants.dividerColor,
                              ),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: AppConstants.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              contextParent.push(
                                AppRoutes.addServiceSpa,
                                extra: service.id.toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Edit Service',
                              style: TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: AppConstants.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showServiceOptions(BuildContext contextParent, Service service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppConstants.primaryColor),
              title: const Text('Edit Service'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit service coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppConstants.errorColor),
              title: const Text('Delete Service'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(contextParent, service);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext contextParent, Service service) {
    showDialog(
      context: contextParent,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        title: const Text('Delete Service'),
        content: Text(
          'Are you sure you want to delete "${service.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await contextParent.read<SpaServiceCubit>().delete(
                service.id.toString(),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
