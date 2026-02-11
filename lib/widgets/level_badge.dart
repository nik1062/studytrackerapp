import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyProvider>(
      builder: (context, studyProvider, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shield, size: 80, color: Colors.amber),
                Text(
                  studyProvider.currentLevel.toString(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Level ${studyProvider.currentLevel}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                value: studyProvider.xpProgress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 4),
            Text('${studyProvider.xpForNextLevel} XP to next level', style: const TextStyle(fontSize: 12)),
          ],
        );
      },
    );
  }
}
