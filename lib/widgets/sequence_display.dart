import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SequenceDisplay extends StatelessWidget {
  final List<String> sequence;

  const SequenceDisplay({
    Key? key,
    required this.sequence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sequence.map((word) => _WordCard(word: word)).toList(),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String word;

  const _WordCard({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          word,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ).animate().fadeIn().scale().slideY(begin: 0.3, end: 0);
  }
}
