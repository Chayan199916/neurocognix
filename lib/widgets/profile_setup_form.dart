import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../screens/game_screen.dart';

class ProfileSetupForm extends StatefulWidget {
  const ProfileSetupForm({Key? key}) : super(key: key);

  @override
  State<ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  String _ageGroup = 'adult';
  String _educationLevel = 'high_school';
  String _languageProficiency = 'intermediate';

  final Map<String, List<String>> _ageGroupIcons = {
    'child': ['🧒', '6-12 years'],
    'teen': ['👦', '13-19 years'],
    'adult': ['👨', '20-59 years'],
    'senior': ['👴', '60+ years'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select your age group',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _ageGroupIcons.entries.map((entry) {
            return _SelectableCard(
              isSelected: _ageGroup == entry.key,
              onTap: () => setState(() => _ageGroup = entry.key),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.value[0],
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(entry.value[1]),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          value: _educationLevel,
          decoration: const InputDecoration(
            labelText: 'Education Level',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'elementary', child: Text('Elementary')),
            DropdownMenuItem(value: 'high_school', child: Text('High School')),
            DropdownMenuItem(value: 'college', child: Text('College')),
            DropdownMenuItem(value: 'graduate', child: Text('Graduate')),
          ],
          onChanged: (value) => setState(() => _educationLevel = value!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _languageProficiency,
          decoration: const InputDecoration(
            labelText: 'Language Proficiency',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
            DropdownMenuItem(
                value: 'intermediate', child: Text('Intermediate')),
            DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
            DropdownMenuItem(value: 'native', child: Text('Native')),
          ],
          onChanged: (value) => setState(() => _languageProficiency = value!),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            final gameProvider = context.read<GameProvider>();
            await gameProvider.startGame(
              _ageGroup,
              _educationLevel,
              _languageProficiency,
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const GameScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Start Game'),
        ),
      ],
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectableCard({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : null,
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
