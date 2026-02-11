import 'package:application_1/providers/weekly_challenge_provider.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import '../widgets/timer_widget.dart';
import '../models/study_session.dart';
import '../services/audio_service.dart';

class FocusScreen extends StatefulWidget {
  final StudySession session;

  const FocusScreen({super.key, required this.session});

  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final AudioService _audioService = AudioService();
  String? _currentSound;

  final List<String> _quotes = [
    "The secret of getting ahead is getting started.",
    "The only way to do great work is to love what you do.",
    "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    "Believe you can and you're halfway there.",
    "The future depends on what you do today.",
  ];

  late String _randomQuote;

  @override
  void initState() {
    super.initState();
    _randomQuote = _quotes[Random().nextInt(_quotes.length)];
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _toggleSound(String soundName) {
    if (_currentSound == soundName) {
      _audioService.stopSound();
      setState(() {
        _currentSound = null;
      });
    } else {
      _audioService.playSound(soundName);
      setState(() {
        _currentSound = soundName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable back button
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerWidget(startTime: widget.session.startTime),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '"$_randomQuote"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 60),
                // Ambient Sound Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.cloudy_snowing, color: _currentSound == 'rain' ? Colors.lightBlueAccent : Colors.white),
                      onPressed: () => _toggleSound('rain'),
                      tooltip: 'Rain',
                    ),
                    IconButton(
                      icon: Icon(Icons.coffee, color: _currentSound == 'cafe' ? Colors.brown[200] : Colors.white),
                      onPressed: () => _toggleSound('cafe'),
                      tooltip: 'Cafe',
                    ),
                    IconButton(
                      icon: Icon(Icons.waves, color: _currentSound == 'white_noise' ? Colors.blue[200] : Colors.white),
                      onPressed: () => _toggleSound('white_noise'),
                      tooltip: 'Ocean Waves',
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async {
                    _audioService.stopSound();
                    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
                    final weeklyChallengeProvider = Provider.of<WeeklyChallengeProvider>(context, listen: false);
                    
                    final duration = await studyProvider.endStudySession();
                    if (duration > 0) {
                      await weeklyChallengeProvider.updateChallengeProgress(duration);
                    }

                    if (context.mounted) { // Check if context is still mounted
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Focus session ended.')),
                      );
                    }
                  },
                  child: const Text('End Focus Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
