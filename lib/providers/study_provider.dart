import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/study_session.dart';
import '../services/hive_service.dart';

class StudyProvider extends ChangeNotifier {
  final Box<StudySession> _studySessionBox = HiveService.getBox<StudySession>(
    'studySessions',
  );

  StudySession? _currentStudySession;

  List<StudySession> get studySessions => _studySessionBox.values.toList();
  StudySession? get currentStudySession => _currentStudySession;

  Future<StudySession?> startStudySession(String subjectId) async {
    if (_currentStudySession != null) {
      // Potentially throw an error or end the previous one, for now, let's just return
      debugPrint(
        'A study session is already active. End it before starting a new one.',
      );
      return null;
    }
    _currentStudySession = StudySession(
      subjectId: subjectId,
      startTime: DateTime.now(),
    );
    notifyListeners();
    return _currentStudySession;
  }

  Future<int> endStudySession() async {
    if (_currentStudySession == null) {
      debugPrint('No study session is active to end.');
      return 0;
    }

    final endTime = DateTime.now();
    _currentStudySession!.endTime = endTime;
    final duration = endTime.difference(_currentStudySession!.startTime).inMinutes;
    _currentStudySession!.durationMinutes = duration;

    await _studySessionBox.put(_currentStudySession!.id, _currentStudySession!);
    _currentStudySession = null;
    notifyListeners();
    return duration;
  }

  // Use for manually adding a completed study session
  Future<void> addStudySession(StudySession session) async {
    // Ensure duration is calculated if not already set, for manual entries
    if (session.durationMinutes == 0 && session.endTime != null) {
      session.durationMinutes = session.endTime!
          .difference(session.startTime)
          .inMinutes;
    }
    await _studySessionBox.put(session.id, session);
    notifyListeners();
  }

  Future<void> updateStudySession(StudySession session) async {
    // Ensure duration is calculated if not already set, for updates
    if (session.durationMinutes == 0 && session.endTime != null) {
      session.durationMinutes = session.endTime!
          .difference(session.startTime)
          .inMinutes;
    }
    await _studySessionBox.put(session.id, session);
    notifyListeners();
  }

  Future<void> deleteStudySession(String id) async {
    await _studySessionBox.delete(id);
    notifyListeners();
  }

  // Get study sessions for a specific subject
  List<StudySession> getSessionsForSubject(String subjectId) {
    return _studySessionBox.values
        .where((session) => session.subjectId == subjectId)
        .toList();
  }

  // Calculate total study hours for a given day
  double getTotalStudyHoursForDay(DateTime day) {
    return _studySessionBox.values
        .where(
          (session) =>
              session.startTime.year == day.year &&
              session.startTime.month == day.month &&
              session.startTime.day == day.day,
        )
        .fold(0.0, (sum, session) => sum + (session.durationMinutes / 60));
  }

  // Calculate total study hours for a given week (Monday to Sunday)
  double getTotalStudyHoursForWeek(DateTime weekStartDate) {
    return _studySessionBox.values
        .where((session) {
          final sessionDate = session.startTime;
          return sessionDate.isAfter(
                weekStartDate.subtract(const Duration(days: 1)),
              ) &&
              sessionDate.isBefore(weekStartDate.add(const Duration(days: 7)));
        })
        .fold(0.0, (sum, session) => sum + (session.durationMinutes / 60));
  }

  // Get daily study hours for a specific week
  Map<DateTime, double> getWeeklyStudyHours(DateTime weekStartDate) {
    final Map<DateTime, double> dailyHours = {};
    for (int i = 0; i < 7; i++) {
      final day = weekStartDate.add(Duration(days: i));
      dailyHours[day] = getTotalStudyHoursForDay(day);
    }
    return dailyHours;
  }

  // Calculate total study hours for all subjects
  double get totalStudyHours {
    return _studySessionBox.values.fold(
      0.0,
      (sum, session) => sum + (session.durationMinutes / 60),
    );
  }

  // Calculate total study hours per subject
  Map<String, double> get studyHoursPerSubject {
    final Map<String, double> hours = {};
    for (var session in _studySessionBox.values) {
      hours.update(
        session.subjectId,
        (value) => value + (session.durationMinutes / 60),
        ifAbsent: () => (session.durationMinutes / 60),
      );
    }
    return hours;
  }

  // Track daily streak
  int get currentStreak {
    if (_studySessionBox.isEmpty) return 0;

    int streak = 0;
    DateTime? lastStudyDay;

    // Sort sessions by date descending
    final sortedSessions = _studySessionBox.values.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    for (var session in sortedSessions) {
      final sessionDay = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      if (lastStudyDay == null) {
        lastStudyDay = sessionDay;
        streak = 1;
      } else {
        final difference = lastStudyDay.difference(sessionDay).inDays;
        if (difference == 1) {
          // Consecutive day
          streak++;
          lastStudyDay = sessionDay;
        } else if (difference == 0) {
          // Same day, do nothing
          // Already counted for this day
        } else {
          // Gap in days, streak broken
          break;
        }
      }
    }
    return streak;
  }

  // Gamification
  static const int xpPerHour = 10;
  static const int xpPerLevel = 100;

  int get totalXp {
    return (totalStudyHours * xpPerHour).toInt();
  }

  int get currentLevel {
    if (totalXp == 0) return 1;
    return (totalXp / xpPerLevel).floor() + 1;
  }

  double get xpProgress {
    if (totalXp == 0) return 0;
    final xpIntoCurrentLevel = totalXp % xpPerLevel;
    return xpIntoCurrentLevel / xpPerLevel;
  }

  int get xpForNextLevel {
    if (totalXp == 0) return xpPerLevel;
    final xpIntoCurrentLevel = totalXp % xpPerLevel;
    return xpPerLevel - xpIntoCurrentLevel;
  }

  // Track longest daily streak
  int get longestStreak {
    if (_studySessionBox.isEmpty) return 0;

    int longest = 0;
    int current = 0;
    DateTime? lastStudyDay;

    final sortedSessions = _studySessionBox.values.toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime)); // Sort ascending for this logic

    for (var session in sortedSessions) {
      final sessionDay = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      if (lastStudyDay == null) {
        current = 1;
      } else {
        final difference = sessionDay.difference(lastStudyDay).inDays;
        if (difference == 1) {
          current++;
        } else if (difference > 1) {
          current = 1; // Streak reset
        }
        // if difference is 0, do nothing
      }
      lastStudyDay = sessionDay;
      if (current > longest) {
        longest = current;
      }
    }
    return longest;
  }
}
