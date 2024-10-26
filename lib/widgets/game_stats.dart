import 'package:flutter/material.dart';

class GameStats extends StatelessWidget {
  final int score;
  final int difficulty;
  final String category;

  const GameStats({
    Key? key,
    required this.score,
    required this.difficulty,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatCard(
          title: 'Score',
          value: score.toString(),
          icon: Icons.stars,
        ),
        _StatCard(
          title: 'Difficulty',
          value: difficulty.toString(),
          icon: Icons.trending_up,
        ),
        _StatCard(
          title: 'Category',
          value: category,
          icon: Icons.category,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
