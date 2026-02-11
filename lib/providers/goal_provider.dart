import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/goal.dart';
import '../services/hive_service.dart';

class GoalProvider extends ChangeNotifier {
  final Box<Goal> _goalBox = HiveService.getBox<Goal>('goals');

  List<Goal> get goals => _goalBox.values.toList();

  List<Goal> get pendingGoals =>
      _goalBox.values.where((goal) => !goal.isCompleted && goal.dueDate.isAfter(DateTime.now().subtract(const Duration(days:1)))).toList();

  List<Goal> get completedGoals =>
      _goalBox.values.where((goal) => goal.isCompleted).toList();

  Future<void> addGoal(String description, int targetMinutes, DateTime dueDate) async {
    final newGoal = Goal(
      description: description,
      targetMinutes: targetMinutes,
      dueDate: dueDate,
    );
    await _goalBox.put(newGoal.id, newGoal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    await _goalBox.put(goal.id, goal);
    notifyListeners();
  }

  Future<void> updateGoalProgress(String goalId, int minutesStudied) async {
    final goal = _goalBox.get(goalId);
    if (goal != null) {
      goal.achievedMinutes += minutesStudied;
      if (goal.achievedMinutes >= goal.targetMinutes) {
        goal.isCompleted = true;
      }
      await goal.save(); // Save changes to Hive
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    await _goalBox.delete(id);
    notifyListeners();
  }

  Goal? getGoalById(String id) {
    return _goalBox.get(id);
  }

  // Helper to get goals due on a specific date (optional, depending on UI needs)
  List<Goal> getGoalsForDate(DateTime date) {
    final searchDate = DateTime(date.year, date.month, date.day);
    return _goalBox.values.where(
      (goal) =>
          goal.dueDate.year == searchDate.year &&
          goal.dueDate.month == searchDate.month &&
          goal.dueDate.day == searchDate.day,
    ).toList();
  }
}
