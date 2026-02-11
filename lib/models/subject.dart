import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart'; // For Color

part 'subject.g.dart';

@HiveType(typeId: 0)
class Subject extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue; // Store color as int

  Subject({String? id, required this.name, required this.colorValue})
    : id = id ?? const Uuid().v4();

  // Helper to get Flutter Color object
  Color get color => Color(colorValue);

  // Helper to set Flutter Color object
  set color(Color color) {
    colorValue = color.toARGB32();
  }
}
