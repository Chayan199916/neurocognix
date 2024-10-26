import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: gameProvider.difficulty / 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Level ${gameProvider.difficulty}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _buildAchievements(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _AchievementBadge(
              icon: Icons.speed,
              label: 'Speed Demon',
              isUnlocked: true,
            ),
            _AchievementBadge(
              icon: Icons.memory,
              label: 'Memory Master',
              isUnlocked: false,
            ),
            _AchievementBadge(
              icon: Icons.psychology,
              label: 'Mind Reader',
              isUnlocked: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isUnlocked;

  const _AchievementBadge({
    Key? key,
    required this.icon,
    required this.label,
    required this.isUnlocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isUnlocked ? Theme.of(context).primaryColor : Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isUnlocked ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}
