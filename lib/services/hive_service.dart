import 'package:hive_flutter/hive_flutter.dart';

import '../models/achievement.dart';
import '../models/goal.dart';
import '../models/study_session.dart';
import '../models/subject.dart';
import '../models/weekly_challenge.dart';

class HiveService {
  static Future<void> initHive() async {
    // Use Hive.initFlutter() which works on all platforms including web
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(AchievementAdapter());
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(StudySessionAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(WeeklyChallengeAdapter()); // New adapter

    // Open boxes
    await Hive.openBox<Achievement>('achievements');
    await Hive.openBox<Goal>('goals');
    await Hive.openBox<StudySession>('studySessions');
    await Hive.openBox<Subject>('subjects');
    await Hive.openBox<WeeklyChallenge>('weeklyChallenges'); // New box
  }

  // Generic function to get a box
  static Box<T> getBox<T>(String name) {
    return Hive.box<T>(name);
  }

  // Generic function to close all boxes (e.g., on app shutdown)
  static Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
