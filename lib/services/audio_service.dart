import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, String> _soundUrls = {
    'rain': 'https://www.soundjay.com/nature/rain-01.mp3',
    'cafe': 'https://www.soundjay.com/ambience/sounds/ambience-cafe-1.mp3',
    'white_noise': 'https://www.soundjay.com/nature/ocean-wave-1.mp3', // Using ocean as white noise
  };

  Future<void> playSound(String soundName) async {
    if (_soundUrls.containsKey(soundName)) {
      try {
        await _audioPlayer.setUrl(_soundUrls[soundName]!);
        await _audioPlayer.setLoopMode(LoopMode.one);
        _audioPlayer.play();
      } catch (e) {
        // Handle error (e.g., network error)
        debugPrint("Error playing sound: $e");
      }
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
