import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  int targetMinutes; // Total minutes to achieve for this goal

  @HiveField(3)
  int achievedMinutes; // Current achieved minutes

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  bool isCompleted;

  Goal({
    String? id,
    required this.description,
    required this.targetMinutes,
    required this.dueDate,
    this.achievedMinutes = 0,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  double get progress => (achievedMinutes / targetMinutes).clamp(0.0, 1.0);
}
