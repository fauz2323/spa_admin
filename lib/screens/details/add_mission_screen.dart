import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/dto/create_mission_dto.dart';
import 'package:spa_admin/screens/details/cubit/add_mission_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

class AddMissionScreen extends StatefulWidget {
  const AddMissionScreen({
    super.key,
    required this.id,
    this.title,
    this.description,
    this.point,
    this.goals,
  });
  final int id;
  final String? title;
  final String? description;
  final String? point;
  final String? goals;

  @override
  State<AddMissionScreen> createState() => _AddMissionScreenState();
}

class _AddMissionScreenState extends State<AddMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    _goalController.dispose();
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
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
