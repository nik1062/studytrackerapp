import 'package:application_1/widgets/glassmorphic_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import '../providers/subject_provider.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold transparent
      // AppBar is in HomeScreen
      body: Consumer2<StudyProvider, SubjectProvider>(
        builder: (context, studyProvider, subjectProvider, child) {
          if (studyProvider.studySessions.isEmpty) {
            return const Center(
              child: Text('Not enough data to show insights.'),
            );
          }

          // Calculate Best Study Day
          final dailyTotals = <DateTime, double>{};
          for (var session in studyProvider.studySessions) {
            final day = DateTime(session.startTime.year, session.startTime.month, session.startTime.day);
            dailyTotals.update(day, (value) => value + session.durationMinutes, ifAbsent: () => session.durationMinutes.toDouble());
          }
          final bestDayEntry = dailyTotals.entries.isEmpty ? null : dailyTotals.entries.reduce((a, b) => a.value > b.value ? a : b);

          // Calculate Most Studied Subject
          final subjectHours = studyProvider.studyHoursPerSubject;
          final mostStudiedSubjectEntry = subjectHours.entries.isEmpty ? null : subjectHours.entries.reduce((a, b) => a.value > b.value ? a : b);
          final mostStudiedSubject = mostStudiedSubjectEntry != null ? subjectProvider.getSubjectById(mostStudiedSubjectEntry.key) : null;
          
          // Calculate Average Daily Hours
          final uniqueDays = studyProvider.studySessions.map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day)).toSet();
          final averageDailyHours = uniqueDays.isEmpty ? 0 : studyProvider.totalStudyHours / uniqueDays.length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildInsightCard(
                icon: Icons.calendar_today,
                title: 'Best Study Day',
                value: bestDayEntry != null ? DateFormat.yMMMEd().format(bestDayEntry.key) : 'N/A',
                subtitle: bestDayEntry != null ? '${(bestDayEntry.value / 60).toStringAsFixed(2)} hours' : '',
              ),
              _buildInsightCard(
                icon: Icons.book,
                title: 'Most Studied Subject',
                value: mostStudiedSubject?.name ?? 'N/A',
                subtitle: mostStudiedSubjectEntry != null ? '${mostStudiedSubjectEntry.value.toStringAsFixed(2)} hours' : '',
              ),
              _buildInsightCard(
                icon: Icons.hourglass_bottom,
                title: 'Average Daily Hours',
                value: '${averageDailyHours.toStringAsFixed(2)} hours',
              ),
              _buildInsightCard(
                icon: Icons.local_fire_department,
                title: 'Current Streak',
                value: '${studyProvider.currentStreak} days',
              ),
              _buildInsightCard(
                icon: Icons.military_tech,
                title: 'Longest Streak',
                value: '${studyProvider.longestStreak} days',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInsightCard({required IconData icon, required String title, required String value, String? subtitle}) {
    return GlassmorphicCard(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            if (subtitle != null && subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
