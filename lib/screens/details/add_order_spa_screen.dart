import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/time_slot_list_model.dart';
import '../../models/user.dart';
import '../../models/service_model.dart';
import '../../network/service_management_network.dart';
import '../../utils/routes.dart';
import '../../utils/time_utils.dart';
import '../../utils/tokien_utils.dart';

class AddOrderSpaScreen extends StatefulWidget {
  const AddOrderSpaScreen({super.key});

  @override
  State<AddOrderSpaScreen> createState() => _AddOrderSpaScreenState();
}

class _AddOrderSpaScreenState extends State<AddOrderSpaScreen> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String token = '';
  ServiceManagementNetwork serviceManagementNetwork =
      ServiceManagementNetwork();

  // Local state to hold selections
  String? _selectedServiceName;
  Service? _selectedService;
  String? _selectedUserName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<TimeSlot>? _availableSlots;

  bool get _isFormValid =>
      _selectedServiceName != null &&
      _selectedUserName != null &&
      _selectedDate != null &&
      _selectedTime != null;

  @override
  void initState() {
    super.initState();

    _fetchToken();
  }

  void _fetchToken() async {
    token = await TokenUtils.getToken() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Order Spa')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Choose Spa Service
          _buildSelectionTile(
            title: 'Pilih Spa Service',
            subtitle: _selectedServiceName ?? 'Belum ada service terpilih',
            icon: Icons.spa,
            onTap: () {
              context.push(
                AppRoutes.chooseSpaService,
                extra: (Service? service) {
                  if (service != null) {
                    setState(() {
                      _selectedService = service;
                      _selectedServiceName = service.name;
                    });
                  }
                },
              );
            },
          ),
          const SizedBox(height: 12),

          // 2. Choose User
          _buildSelectionTile(
            title: 'Pilih User',
            subtitle: _selectedUserName ?? 'Belum ada user terpilih',
            icon: Icons.person,
            onTap: () {
              context.push(
                AppRoutes.chooseUser,
                extra: (User? user) {
                  if (user != null) {
                    setState(() {
                      _selectedUserName = user.name;
                    });
                  }
                },
              );
            },
          ),
          const SizedBox(height: 12),

          if (_selectedService != null) ...{
            // 3. Choose Date
            _buildSelectionTile(
              title: 'Pilih Tanggal',
              subtitle: _selectedDate == null
                  ? 'Belum ada jadwal terpilih'
                  : DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate!),
              icon: Icons.calendar_today,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  _availableSlots = null;
                  await setDate(picked);
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
          },

          if (_availableSlots != null) ...{
            // 4. Choose Time
            _buildSelectionTile(
              title: 'Pilih Waktu',
              subtitle: _selectedTime == null
                  ? 'Belum ada waktu terpilih'
                  : _selectedTime!.to24HourString(),
              icon: Icons.calendar_today,
              onTap: () async {
                // fetch from
                final pickedSlot = await showTimeSlotPickerDialog(
                  context,
                  _availableSlots!,
                );

                if (pickedSlot != null) {
                  final time = pickedSlot.timeStart.split(':');
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: int.parse(time[0]),
                      minute: int.parse(time[1]),
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 12),
          },
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: _isFormValid ? Colors.teal : Colors.grey,
          ),
          onPressed: _isFormValid
              ? () async {
                  // TODO: Implement Save Logic (Cubit/API call)
                  await createOrder();
                }
              : null,
          child: const Text(
            'SIMPAN ORDER',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: Icon(icon, color: Colors.teal),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: subtitle.contains('Belum') ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<TimeSlot?> showTimeSlotPickerDialog(
    BuildContext context,
    List<TimeSlot> slots,
  ) async {
    return showDialog<TimeSlot>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(children: [Text('Pilih Jadwal')]),
          content: SizedBox(
            width: double.maxFinite,
            height: 320,
            child: Scrollbar(
              thumbVisibility: true, // Always show scrollbar [web:154]
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: slots.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return ListTile(
                    leading: const Icon(Icons.access_time, size: 20),
                    title: Text('${slot.timeStart} - ${slot.timeEnd}'),
                    trailing: index < slots.length - 1
                        ? const Icon(Icons.arrow_forward_ios, size: 16)
                        : null,
                    onTap: () => Navigator.of(context).pop(slot),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> setDate(DateTime date) async {
    final dateStr = dateFormatter.format(date);
    final duration = _selectedService!.duration;
    final timeSlotResponse = await serviceManagementNetwork
        .getAvailableTimeSlots(token, dateStr);

    timeSlotResponse.fold(
      (networkError) {
        // emit(BookingPageState.error(message: networkError.message));
      },
      (timeSlot) {
        setState(() {
          _availableSlots = _getTimeSlotByDuration(timeSlot.data, duration);
        });
      },
    );
  }

  List<TimeSlot> _getTimeSlotByDuration(List<TimeSlot> slots, int duration) {
    final slotDuration = 15;
    final requiredSlots = (duration / slotDuration).ceil();

    final List<TimeSlot> availableStarts = [];

    // Single pass: track consecutive available slots
    int consecutiveAvailable = 0;

    for (int i = 0; i < slots.length; i++) {
      if (slots[i].available) {
        consecutiveAvailable++;

        // Check if we have enough consecutive slots ending at i
        if (consecutiveAvailable >= requiredSlots) {
          // Find start: i - requiredSlots + 1
          final startIndex = i - requiredSlots + 1;
          availableStarts.add(
            TimeSlot(
              timeStart: slots[startIndex].timeStart,
              timeEnd: slots[i].timeEnd,
              available: true,
            ),
          );
        }
      } else {
        consecutiveAvailable = 0; // Reset counter
      }
    }

    return availableStarts;
  }

  Future<void> createOrder() async {
    try {
      final orderMakeResponse = await serviceManagementNetwork.createOrder(
        token,
        _selectedService!.id.toString(),
        _selectedTime!.to24HourString(),
        _selectedDate!.toString().split(' ')[0],
        '',
      );

      orderMakeResponse.fold(
        (networkError) {
          if (networkError.statusCode == 401) {
          } else {

          }
        },
        (data) {
          setState(() {
            _selectedTime = null;
            _availableSlots = null;
            _selectedDate = null;
            _selectedService = null;
          });
          // success create order
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order berhasil disimpan')),
          );
        },
      );
    } catch (e) {}
  }
}
