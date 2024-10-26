import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameProvider with ChangeNotifier {
  int _score = 0;
  int _difficulty = 5;
  String _currentCategory = '';
  List<String> _sequence = [];
  bool _isLoading = false;
  String _playerAgeGroup = 'adult';
  String _educationLevel = 'high_school';
  String _languageProficiency = 'intermediate';

  // Getters
  int get score => _score;
  int get difficulty => _difficulty;
  String get currentCategory => _currentCategory;
  List<String> get sequence => _sequence;
  bool get isLoading => _isLoading;

  Future<void> startGame(
      String ageGroup, String educationLevel, String proficiency) async {
    _isLoading = true;
    notifyListeners();

    _playerAgeGroup = ageGroup;
    _educationLevel = educationLevel;
    _languageProficiency = proficiency;

    try {
      final response = await http.post(
        Uri.parse('https://3482-34-127-90-7.ngrok-free.app/start-game'),
        body: jsonEncode({
          'age_group': _playerAgeGroup,
          'education_level': _educationLevel,
          'language_proficiency': _languageProficiency,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      _sequence = (data['sequence'] as String).split(' ');
      _currentCategory = data['category'];
      _difficulty = data['difficulty'];
    } catch (e) {
      print('Error starting game: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> submitAnswer(
      String answer, double startTime, double endTime) async {
    try {
      final response = await http.post(
        Uri.parse('https://3482-34-127-90-7.ngrok-free.app/submit-answer'),
        body: jsonEncode({
          'answer': answer,
          'startTime': startTime,
          'endTime': endTime,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      _score = data['totalScore'];
      _difficulty = data['newDifficulty'];
      notifyListeners();
      return data;
    } catch (e) {
      print('Error submitting answer: $e');
      return {};
    }
  }

  Future<void> generateNewSequence() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://3482-34-127-90-7.ngrok-free.app/generate-sequence'),
      );

      final data = jsonDecode(response.body);
      _sequence = (data['sequence'] as String).split(' ');
      _currentCategory = data['category'];
      _difficulty = data['difficulty'];
    } catch (e) {
      print('Error generating sequence: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
