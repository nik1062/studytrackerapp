import 'package:application_1/widgets/glassmorphic_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/goal_provider.dart';
import 'goal_form_screen.dart';

class GoalsListScreen extends StatelessWidget {
  const GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // AppBar is in HomeScreen
      body: SafeArea(
        child: Consumer<GoalProvider>(
          builder: (context, goalProvider, child) {
            final pendingGoals = goalProvider.pendingGoals;
            final completedGoals = goalProvider.completedGoals;

            if (pendingGoals.isEmpty && completedGoals.isEmpty) {
              return const Center(
                child: Text("No goals added yet. Tap '+' to add one.", style: TextStyle(color: Colors.white)),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (pendingGoals.isNotEmpty) ...[
                  const Text('Pending Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ...pendingGoals.map((goal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GlassmorphicCard(
                      child: ListTile(
                        title: Text(goal.description, style: const TextStyle(color: Colors.white)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Due: ${DateFormat.yMd().format(goal.dueDate)}', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: goal.progress,
                              backgroundColor: Colors.white.withAlpha(76), // 0.3 opacity
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                            ),
                            Text('${(goal.progress * 100).toStringAsFixed(0)}% complete', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GoalFormScreen(goal: goal),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white70),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: Text('Do you want to delete the goal "${goal.description}"?'),
                                actions: <Widget>[
                                  TextButton(child: const Text('No'), onPressed: () => Navigator.of(ctx).pop()),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      goalProvider.deleteGoal(goal.id);
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Goal deleted successfully!')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )),
                ],
                if (completedGoals.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Completed Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ...completedGoals.map((goal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GlassmorphicCard(
                      child: ListTile(
                        title: Text(goal.description, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white70)),
                        subtitle: Text('Completed on: ${DateFormat.yMd().format(goal.dueDate)}', style: const TextStyle(color: Colors.white70)),
                        leading: const Icon(Icons.check_circle, color: Colors.greenAccent),
                      ),
                    ),
                  )),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GoalFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

