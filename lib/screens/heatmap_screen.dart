import 'package:flutter/material.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is in HomeScreen
      body: Consumer<StudyProvider>(
        builder: (context, studyProvider, child) {
          final studySessions = studyProvider.studySessions;

          if (studySessions.isEmpty) {
            return const Center(
              child: Text('No study data to display on the heatmap.'),
            );
          }

          // Process the study data
          final Map<DateTime, int> heatMapData = {};
          for (var session in studySessions) {
            final day = DateTime(session.startTime.year, session.startTime.month, session.startTime.day);
            heatMapData.update(
              day,
              (value) => value + session.durationMinutes,
              ifAbsent: () => session.durationMinutes,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                HeatMap(
                  datasets: heatMapData,
                  startDate: DateTime.now().subtract(const Duration(days: 180)),
                  endDate: DateTime.now(),
                  colorMode: ColorMode.color,
                  showColorTip: true,
                  showText: true,
                  scrollable: true,
                  colorsets: const {
                    1: Colors.green, // You can customize these colors
                    3: Colors.orange,
                    5: Colors.red,
                  },
                  onClick: (value) {
                    final minutes = heatMapData[value] ?? 0;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$minutes minutes on ${value.toIso8601String().substring(0, 10)}')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
