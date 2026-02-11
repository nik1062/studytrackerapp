import 'package:application_1/widgets/glassmorphic_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subject_provider.dart';
import 'subject_form_screen.dart';

class SubjectsListScreen extends StatelessWidget {
  const SubjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // The AppBar is now in HomeScreen, so we don't need it here.
      body: SafeArea(
        child: Consumer<SubjectProvider>(
          builder: (context, subjectProvider, child) {
            final subjects = subjectProvider.subjects;
            if (subjects.isEmpty) {
              return const Center(
                child: Text("No subjects added yet. Tap '+' to add one.", style: TextStyle(color: Colors.white)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GlassmorphicCard(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: subject.color,
                        child: const SizedBox.shrink(),
                      ),
                      title: Text(subject.name, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubjectFormScreen(subject: subject),
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
                              content: Text('Do you want to delete the subject "${subject.name}"?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    subjectProvider.deleteSubject(subject.id);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Subject deleted successfully!')),
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
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SubjectFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
