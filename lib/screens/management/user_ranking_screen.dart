import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/models/users_points_model.dart';
import 'package:spa_admin/screens/management/cubit/user_rank_cubit.dart';
import 'package:spa_admin/utils/tokien_utils.dart';
import '../../models/user.dart';
import '../../utils/routes.dart';

class UserRankingScreen extends StatefulWidget {
  const UserRankingScreen({super.key});

  @override
  State<UserRankingScreen> createState() => _UserRankingScreenState();
}

class _UserRankingScreenState extends State<UserRankingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserRankCubit()..initial(),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          'User Ranking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<UserRankCubit, UserRankState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthorized: () async {
              await TokenUtils.deleteAllTokens();
              // Handle unauthorized state, e.g., navigate to login
              context.go(AppRoutes.login);
            },
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Container(),
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            loaded: (data) {
              return _loaded(context, data);
            },
            error: (message) => Center(
              child: Text(
                'Error: $message',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, UsersPointsModel data) {
    return Column(
      children: [
        // Period Selector and Stats
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Period Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'User Rankings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Top performers by reward points',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Top 3 Stats
              if (data.data.isNotEmpty)
                _buildTopThreeStats(data.data.take(3).toList()),
            ],
          ),
        ),

        // Rankings List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: data.data.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No rankings available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      final user = data.data[index];
                      final rank = index + 1;
                      return _buildRankingCard(user, rank);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopThreeStats(List<Datum> users) {
    return Row(
      children: [
        // 2nd Place
        if (users.length > 1)
          Expanded(child: _buildPodiumCard(users[1], 2, Colors.grey.shade600)),
        const SizedBox(width: 8),

        // 1st Place
        if (users.isNotEmpty)
          Expanded(child: _buildPodiumCard(users[0], 1, Colors.amber)),
        const SizedBox(width: 8),

        // 3rd Place
        if (users.length > 2)
          Expanded(
            child: _buildPodiumCard(users[2], 3, Colors.orange.shade700),
          ),
      ],
    );
  }

  Widget _buildPodiumCard(Datum user, int rank, Color color) {
    IconData medalIcon;
    switch (rank) {
      case 1:
        medalIcon = Icons.emoji_events;
        break;
      case 2:
        medalIcon = Icons.military_tech;
        break;
      case 3:
        medalIcon = Icons.workspace_premium;
        break;
      default:
        medalIcon = Icons.star;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(medalIcon, color: color, size: rank == 1 ? 32 : 28),
          const SizedBox(height: 8),
          Text(
            user.user.name.split(' ').first,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${user.points} pts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingCard(Datum user, int rank) {
    Color rankColor;
    IconData rankIcon;

    if (rank <= 3) {
      switch (rank) {
        case 1:
          rankColor = Colors.amber;
          rankIcon = Icons.emoji_events;
          break;
        case 2:
          rankColor = Colors.grey.shade600;
          rankIcon = Icons.military_tech;
          break;
        case 3:
          rankColor = Colors.orange.shade700;
          rankIcon = Icons.workspace_premium;
          break;
        default:
          rankColor = Colors.grey;
          rankIcon = Icons.star;
      }
    } else {
      rankColor = Colors.grey;
      rankIcon = Icons.person;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: rank <= 3 ? 6 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: rank <= 3
            ? BorderSide(color: rankColor.withOpacity(0.3), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          context.push('${AppRoutes.userDetail}/${user.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: rankColor.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (rank <= 3)
                      Icon(rankIcon, color: rankColor, size: 20)
                    else
                      Text(
                        '#$rank',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Profile Picture
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

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'active',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),

              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.points}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'points',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
