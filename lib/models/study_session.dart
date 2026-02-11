import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'study_session.g.dart';

@HiveType(typeId: 1)
class StudySession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subjectId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  int durationMinutes;

  @HiveField(5)
  String? notes;

  StudySession({
    String? id,
    required this.subjectId,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.notes,
  }) : id = id ?? const Uuid().v4();
}
