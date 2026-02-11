import 'package:application_1/widgets/level_badge.dart';
import 'package:application_1/widgets/weekly_challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import '../providers/subject_provider.dart';
import '../models/subject.dart';
import '../widgets/timer_widget.dart';
import 'focus_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showSubjectSelectionDialog(BuildContext context, StudyProvider studyProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Subject'),
          content: Consumer<SubjectProvider>(
            builder: (context, subjectProvider, child) {
              if (subjectProvider.subjects.isEmpty) {
                return const Text('No subjects available. Please add a subject first.');
              }
              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectProvider.subjects.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Subject subject = subjectProvider.subjects[index];
                    return ListTile(
                      title: Text(subject.name),
                      leading: CircleAvatar(backgroundColor: subject.color),
                      onTap: () async {
                        final newSession = await studyProvider.startStudySession(subject.id);
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Close the dialog first
                          if (newSession != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FocusScreen(session: newSession),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // The AppBar is in HomeScreen
      body: SafeArea(
        child: Consumer2<StudyProvider, SubjectProvider>(
          builder: (context, studyProvider, subjectProvider, child) {
            final currentSession = studyProvider.currentStudySession;

            if (currentSession != null) {
              final subject = subjectProvider.getSubjectById(currentSession.subjectId);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Currently Studying: ${subject?.name ?? "Unknown Subject"}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TimerWidget(startTime: currentSession.startTime),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FocusScreen(session: currentSession),
                          ),
                        );
                      },
                      child: const Text('Return to Focus Mode'),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LevelBadge(),
                      const SizedBox(height: 20),
                      const WeeklyChallengeCard(),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => _showSubjectSelectionDialog(context, studyProvider),
                        child: const Text('Start Studying'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
