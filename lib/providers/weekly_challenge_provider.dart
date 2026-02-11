import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/weekly_challenge.dart';
import '../services/hive_service.dart';

class WeeklyChallengeProvider extends ChangeNotifier {
  final Box<WeeklyChallenge> _challengeBox = HiveService.getBox<WeeklyChallenge>('weeklyChallenges');

  WeeklyChallenge? _currentChallenge;

  WeeklyChallenge? get currentChallenge => _currentChallenge;

  WeeklyChallengeProvider() {
    _loadCurrentChallenge();
  }

  void _loadCurrentChallenge() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    _currentChallenge = _challengeBox.values.firstWhere(
      (c) => c.startDate == startOfWeekDate,
      orElse: () {
        final newChallenge = WeeklyChallenge(
          title: 'Study 20 hours this week',
          targetMinutes: 20 * 60,
          startDate: startOfWeekDate,
        );
        _challengeBox.put(newChallenge.id, newChallenge);
        return newChallenge;
      },
    );
    notifyListeners();
  }

  Future<void> updateChallengeProgress(int minutes) async {
    if (_currentChallenge != null) {
      _currentChallenge!.achievedMinutes += minutes;
      if (_currentChallenge!.achievedMinutes >= _currentChallenge!.targetMinutes) {
        _currentChallenge!.isCompleted = true;
      }
      await _challengeBox.put(_currentChallenge!.id, _currentChallenge!);
      notifyListeners();
    }
  }
}
