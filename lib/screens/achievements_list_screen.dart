import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/achievement_provider.dart';

class AchievementsListScreen extends StatelessWidget {
  const AchievementsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is in HomeScreen
      body: Consumer<AchievementProvider>(
        builder: (context, achievementProvider, child) {
          final achievements = achievementProvider.achievements;
          return ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Opacity(
                opacity: achievement.isUnlocked ? 1.0 : 0.5,
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      achievement.isUnlocked ? Icons.star : Icons.star_border,
                      color: achievement.isUnlocked
                          ? Colors.amber
                          : Colors.grey,
                      size: 40,
                    ),
                    title: Text(achievement.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(achievement.description),
                        if (achievement.isUnlocked &&
                            achievement.unlockedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Unlocked: ${DateFormat.yMd().format(achievement.unlockedDate!)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final achievementProvider = Provider.of<AchievementProvider>(
            context,
            listen: false,
          );
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          await achievementProvider.checkAchievements(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Achievements checked!')),
          );
        },
        tooltip: 'Check Achievements',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
