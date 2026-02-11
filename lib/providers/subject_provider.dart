import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/subject.dart';
import '../services/hive_service.dart';

class SubjectProvider extends ChangeNotifier {
  final Box<Subject> _subjectBox = HiveService.getBox<Subject>('subjects');

  List<Subject> get subjects => _subjectBox.values.toList();

  Future<void> addSubject(String name, Color color) async {
    final newSubject = Subject(name: name, colorValue: color.toARGB32());
    await _subjectBox.put(newSubject.id, newSubject);
    notifyListeners();
  }

  Future<void> updateSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
    notifyListeners();
  }

  Future<void> deleteSubject(String id) async {
    await _subjectBox.delete(id);
    notifyListeners();
  }

  Subject? getSubjectById(String id) {
    return _subjectBox.get(id);
  }
}
