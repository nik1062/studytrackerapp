import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/achievement.dart';
import '../services/hive_service.dart';
import 'study_provider.dart'; // To listen for study hours
import 'package:provider/provider.dart';

class AchievementProvider extends ChangeNotifier {
  final Box<Achievement> _achievementBox = HiveService.getBox<Achievement>('achievements');

  List<Achievement> get achievements => _achievementBox.values.toList();

  AchievementProvider() {
    _initializeAchievements();
  }

  Future<void> _initializeAchievements() async {
    // Define all possible achievements here
    // Only add if not already present
    if (_achievementBox.get('first_5_hours') == null) {
      await _achievementBox.put(
        'first_5_hours',
        Achievement(
          id: 'first_5_hours',
          name: 'First 5 Hours!',
          description: 'Completed 5 hours of study.',
          isUnlocked: false,
          unlockedDate: null, // Initially locked
        ),
      );
    }
    if (_achievementBox.get('seven_day_streak') == null) {
      await _achievementBox.put(
        'seven_day_streak',
        Achievement(
          id: 'seven_day_streak',
          name: '7-Day Streak!',
          description: 'Achieved a 7-day study streak.',
          isUnlocked: false,
          unlockedDate: null, // Initially locked
        ),
      );
    }
    if (_achievementBox.get('twenty_hours_milestone') == null) {
      await _achievementBox.put(
        'twenty_hours_milestone',
        Achievement(
          id: 'twenty_hours_milestone',
          name: '20 Hours Milestone!',
          description: 'Completed 20 hours of study.',
          isUnlocked: false,
          unlockedDate: null, // Initially locked
        ),
      );
    }
    notifyListeners();
  }

  Future<void> checkAchievements(BuildContext context) async {
    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
    final totalStudyHours = studyProvider.totalStudyHours;
    final currentStreak = studyProvider.currentStreak;

    // Check "First 5 Hours!"
    Achievement? first5Hours = _achievementBox.get('first_5_hours');
    if (first5Hours != null && !first5Hours.isUnlocked && totalStudyHours >= 5) {
      await updateAchievement(first5Hours.copyWith(isUnlocked: true, unlockedDate: DateTime.now()));
    }

    // Check "7-Day Streak!"
    Achievement? sevenDayStreak = _achievementBox.get('seven_day_streak');
    if (sevenDayStreak != null && !sevenDayStreak.isUnlocked && currentStreak >= 7) {
      await updateAchievement(sevenDayStreak.copyWith(isUnlocked: true, unlockedDate: DateTime.now()));
    }

    // Check "20 Hours Milestone!"
    Achievement? twentyHoursMilestone = _achievementBox.get('twenty_hours_milestone');
    if (twentyHoursMilestone != null && !twentyHoursMilestone.isUnlocked && totalStudyHours >= 20) {
      await updateAchievement(twentyHoursMilestone.copyWith(isUnlocked: true, unlockedDate: DateTime.now()));
    }
    notifyListeners();
  }

  Future<void> addAchievement(Achievement achievement) async {
    await _achievementBox.put(achievement.id, achievement);
    notifyListeners();
  }

  Future<void> updateAchievement(Achievement achievement) async {
    await _achievementBox.put(achievement.id, achievement);
    notifyListeners();
  }

  Future<void> deleteAchievement(String id) async {
    await _achievementBox.delete(id);
    notifyListeners();
  }

  Achievement? getAchievementById(String id) {
    return _achievementBox.get(id);
  }
}
