import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'achievement.g.dart';

@HiveType(typeId: 3)
class Achievement extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime? unlockedDate;

  @HiveField(4)
  bool isUnlocked;

  Achievement({
    String? id,
    required this.name,
    required this.description,
    this.unlockedDate,
    this.isUnlocked = false,
  }) : id = id ?? const Uuid().v4();

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? unlockedDate,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
