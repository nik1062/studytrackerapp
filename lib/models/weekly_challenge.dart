import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'weekly_challenge.g.dart';

@HiveType(typeId: 4) // Using a new typeId
class WeeklyChallenge extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int targetMinutes;

  @HiveField(3)
  int achievedMinutes;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  bool isCompleted;

  WeeklyChallenge({
    String? id,
    required this.title,
    required this.targetMinutes,
    required this.startDate,
    this.achievedMinutes = 0,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  double get progress => (achievedMinutes / targetMinutes).clamp(0.0, 1.0);
}
