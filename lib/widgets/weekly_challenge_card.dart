import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weekly_challenge_provider.dart';
import 'glassmorphic_card.dart';

class WeeklyChallengeCard extends StatelessWidget {
  const WeeklyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeeklyChallengeProvider>(
      builder: (context, challengeProvider, child) {
        final challenge = challengeProvider.currentChallenge;

        if (challenge == null) {
          return const SizedBox.shrink(); // Or a loading indicator
        }

        return GlassmorphicCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(challenge.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: challenge.progress,
                  backgroundColor: Colors.white.withAlpha(76), // 0.3 opacity
                  valueColor: AlwaysStoppedAnimation<Color>(challenge.isCompleted ? Colors.greenAccent : Colors.amber),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(challenge.achievedMinutes / 60).toStringAsFixed(1)} / ${challenge.targetMinutes / 60} hours',
                  style: const TextStyle(color: Colors.white70),
                ),
                if (challenge.isCompleted) ...[
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.greenAccent),
                      SizedBox(width: 8),
                      Text('Challenge Completed!', style: TextStyle(color: Colors.greenAccent)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
