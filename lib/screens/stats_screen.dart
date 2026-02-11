import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/study_provider.dart';
import '../providers/subject_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is in HomeScreen
      body: Consumer2<StudyProvider, SubjectProvider>(
        builder: (context, studyProvider, subjectProvider, child) {
          final totalStudyHours = studyProvider.totalStudyHours;

          if (totalStudyHours == 0) {
            return const Center(
              child: Text('No study data available to show stats.'),
            );
          }

          // Data for Pie Chart
          final studyHoursPerSubject = studyProvider.studyHoursPerSubject;
          final List<PieChartSectionData> pieChartSections =
              studyHoursPerSubject.entries.map((entry) {
                final subject = subjectProvider.getSubjectById(entry.key);
                final percentage = (entry.value / totalStudyHours) * 100;
                return PieChartSectionData(
                  color: subject?.color ?? Colors.grey,
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList();

          // Data for Bar Chart
          final today = DateTime.now();
          final weekStartDate = today.subtract(
            Duration(days: today.weekday - 1),
          );
          final weeklyData = studyProvider.getWeeklyStudyHours(weekStartDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Statistics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Study Hours: ${totalStudyHours.toStringAsFixed(2)}',
                ),
                Text('Current Streak: ${studyProvider.currentStreak} days'),

                const SizedBox(height: 30),
                const Text(
                  'Study Hours by Subject',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      // Add a legend to the pie chart
                      // Consider using a custom legend widget alongside the PieChart
                      // for better control over layout and responsiveness.
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Custom Legend for Pie Chart
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: studyHoursPerSubject.entries.map((entry) {
                    final subject = subjectProvider.getSubjectById(entry.key);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: subject?.color ?? Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(subject?.name ?? 'Unknown'),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),
                const Text(
                  'This Week\'s Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY:
                          weeklyData.values.reduce((a, b) => a > b ? a : b) *
                          1.2, // Add 20% buffer
                      barGroups: weeklyData.entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key.weekday,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Theme.of(context).primaryColor,
                              width: 16,
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ];
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(days[value.toInt() - 1]),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
