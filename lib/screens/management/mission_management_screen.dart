import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spa_admin/dto/create_mission_dto.dart';
import 'package:spa_admin/models/list_mission_model.dart';
import 'package:spa_admin/screens/management/cubit/mission_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

class MissionManagementScreen extends StatelessWidget {
  const MissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MissionCubit()..initial(),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Management'),
        backgroundColor: Colors.teal,
      ),
      body: BlocConsumer<MissionCubit, MissionState>(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new mission
          context.push(AppRoutes.addMission);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _loaded(BuildContext context, ListMissionModel data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.data.length,
      itemBuilder: (context, index) {
        final mission = data.data[index];
        return _buildMissionCard(mission, context);
      },
    );
  }

  Widget _buildMissionCard(Datum mission, BuildContext context) {
    final createdAt = DateTime.parse(mission.createdAt.toString());
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
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
                    mission.title,
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
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${mission.points} pts',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              mission.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.flag, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Goal: ${mission.goal}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    context.push(
                      AppRoutes.addMission,
                      extra: CreateMissionDto(
                        title: mission.title,
                        description: mission.description,
                        points: int.parse(mission.points),
                        goal: mission.goal,
                        id: mission.id.toString(),
                      ),
                    );
                  },
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // TODO: Delete mission
                  },
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
