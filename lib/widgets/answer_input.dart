import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class AnswerInput extends StatefulWidget {
  final VoidCallback onNewSequence;

  const AnswerInput({
    Key? key,
    required this.onNewSequence,
  }) : super(key: key);

  @override
  State<AnswerInput> createState() => _AnswerInputState();
}

class _AnswerInputState extends State<AnswerInput> {
  final _controller = TextEditingController();
  double? _startTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch / 1000;
  }

  Future<void> _handleSubmission() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    final endTime = DateTime.now().millisecondsSinceEpoch / 1000;

    try {
      final gameProvider = context.read<GameProvider>();
      final result = await gameProvider.submitAnswer(
        _controller.text,
        _startTime!,
        endTime,
      );

      _controller.clear();

      // Generate new sequence only if the answer was correct
      if (result['correct'] == true) {
        await gameProvider.generateNewSequence();
        widget.onNewSequence();
      } else {
        // Show feedback for incorrect answer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Incorrect! Try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      _startTime = DateTime.now().millisecondsSinceEpoch / 1000;
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Type what you remember...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (_) => _handleSubmission(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmission,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
