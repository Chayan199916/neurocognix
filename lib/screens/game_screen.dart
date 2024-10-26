import 'dart:async';

import 'package:cognitive_app/user/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cognitive_app/widgets/progress_tracker.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/sequence_display.dart';
import '../widgets/answer_input.dart';
import '../widgets/game_stats.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showSequence = true;
  bool _showInput = false;
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startMemorizationPhase();
  }

  void _startMemorizationPhase() {
    final gameProvider = context.read<GameProvider>();
    // Calculate display time based on sequence length and difficulty
    final baseTimePerWord = 2; // seconds
    _remainingTime =
        (baseTimePerWord * gameProvider.sequence.length).clamp(5, 15);

    setState(() {
      _showSequence = true;
      _showInput = false;
    });

    // Start countdown timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _showSequence = false;
          _showInput = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving the game
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave Game?'),
            content: const Text('Your progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Leave'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, _) {
              if (gameProvider.isLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Preparing next sequence...'),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Row(
                          children: [
                            if (_showSequence)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Time: $_remainingTime s',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: const FeedbackForm(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.feedback_outlined),
                              tooltip: 'Provide Feedback',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GameStats(
                      score: gameProvider.score,
                      difficulty: gameProvider.difficulty,
                      category: gameProvider.currentCategory,
                    )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500))
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 32),
                    if (_showSequence) ...[
                      const Text(
                        'Memorize the sequence!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 16),
                      SequenceDisplay(sequence: gameProvider.sequence)
                          .animate()
                          .fadeIn(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                          )
                          .scale(begin: const Offset(0.8, 0.8)),
                    ],
                    if (_showInput) ...[
                      const Text(
                        'Type what you remember',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 16),
                      AnswerInput(
                        onNewSequence: _startMemorizationPhase,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 300))
                          .slideY(begin: 0.2, end: 0),
                    ],
                    const SizedBox(height: 32),
                    const ProgressTracker()
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 600))
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
