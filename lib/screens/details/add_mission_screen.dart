import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/dto/create_mission_dto.dart';
import 'package:spa_admin/screens/details/cubit/add_mission_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

import '../../models/service_model.dart';
import '../management/service_picker_page.dart';

class AddMissionScreen extends StatefulWidget {
  const AddMissionScreen({
    super.key,
    required this.id,
    this.title,
    this.description,
    this.point,
    this.goals,
    this.backCallback,
  });

  final int id;
  final String? title;
  final String? description;
  final String? point;
  final String? goals;
  final Function()? backCallback;

  @override
  State<AddMissionScreen> createState() => _AddMissionScreenState();
}

class _AddMissionScreenState extends State<AddMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _goalController = TextEditingController();
  final _expiredDateController = TextEditingController();
  String servicePicked = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    _goalController.dispose();
    _expiredDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMissionCubit()..initial(widget.id.toString()),
      child: Builder(
        builder: (context) {
          return _build(context);
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow the pop to happen
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.backCallback?.call();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Mission'),
          backgroundColor: Colors.blue,
        ),
        body: BlocConsumer<AddMissionCubit, AddMissionState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              initial: () {
                _titleController.text = widget.title ?? '';
                _descriptionController.text = widget.description ?? '';
                _pointsController.text = widget.point ?? '';
                _goalController.text = widget.goals ?? '';
              },
              loaded: (data) {
                _titleController.text = data.data.title;
                _descriptionController.text = data.data.description;
                _pointsController.text = data.data.points;
                _goalController.text = data.data.goal.toString();
                _expiredDateController.text = data.data.expiredDate;
                servicePicked = data.data.services ?? '';
              },
              unauthorized: () async {
                await TokenUtils.deleteAllTokens();
                context.go(AppRoutes.login);
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => _loaded(context, false),
              loading: () => _loaded(context, true),
            );
          },
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter mission title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              maxLength: 255,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter mission description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Points Field
            TextFormField(
              controller: _pointsController,
              decoration: const InputDecoration(
                labelText: 'Points',
                hintText: 'Enter points',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star),
              ),
              maxLength: 255,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter points';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Goal Field
            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Goal',
                hintText: 'Enter goal number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a goal';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            _buildSelectExpiredDate(context),

            const SizedBox(height: 16),
            _buildSelectServicesDate(context),

            if (_shouldDisplaySaveButton()) ...{
              const SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<AddMissionCubit>().submitMission(
                            CreateMissionDto(
                              id: widget.id == 0 ? null : widget.id.toString(),
                              title: _titleController.text,
                              description: _descriptionController.text,
                              points: int.parse(_pointsController.text),
                              goal: int.parse(_goalController.text),
                              expiredDate: _expiredDateController.text,
                              serviceList: servicePicked,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mission saved')),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isLoading ? 'Saving...' : 'Save Mission',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  bool _shouldDisplaySaveButton() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _pointsController.text.isNotEmpty &&
        _goalController.text.isNotEmpty &&
        _expiredDateController.text.isNotEmpty &&
        servicePicked.isNotEmpty;
  }

  Widget _buildSelectExpiredDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _expiredDateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Expired Date',
              hintText: 'Enter Expired Date',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.access_time),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _pickExpiredDate,
        ),
      ],
    );
  }

  Future<void> _pickExpiredDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _expiredDateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(_expiredDateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ); // [web:22]

    if (selected != null) {
      _expiredDateController.text =
          '${selected.year.toString().padLeft(4, '0')}-'
          '${selected.month.toString().padLeft(2, '0')}-'
          '${selected.day.toString().padLeft(2, '0')}';
    }
    setState(() {});
  }

  Widget _buildSelectServicesDate(BuildContext context) {
    final cubit = context.read<AddMissionCubit>();

    return ElevatedButton(
      onPressed: () => _pickServices(context, cubit.listService),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(
        'Pilih Service',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _pickServices(BuildContext context, List<Service> serviceList) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePickerPage(
          serviceList: serviceList,
          initialPicked: servicePicked,
        ),
      ),
    ); // [web:50][web:53]

    if (result != null && result.isNotEmpty) {
      servicePicked = result;
      setState(() {});
    }
  }
}
