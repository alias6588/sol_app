import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/midi_player.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';
import 'package:sol/models/part.dart';

class MusicPlayNotifier extends ChangeNotifier {
  final List<Part> parts;

  int measureIndex = 0;
  int playingElementIndex = 0;
  bool _isPlaying = false;
  int _currentBpm = 60.clamp(20, 240); // Default BPM
  int get currentBpm => _currentBpm;

  MusicPlayNotifier({required this.parts});

  bool get isPlaying => _isPlaying;

  MidiPlayer get midiPlayer => MidiPlayer();

  Future<void> play() async {
    await midiPlayer.loadSoundfont();
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();

    final beatDurationMs = (60000 / _currentBpm).round();

    final measureSize = parts
        .map((part) => part.measures.length)
        .reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < measureSize; i++) {
      for (final part in parts) {
        if (i < part.measures.length) {
          measureIndex = i;
          final measure = part.measures[i];

          await _playMeasure(measure, beatDurationMs);

          if (!_isPlaying) break;
        }
        if (!_isPlaying) break;
      }
    }

    stop();
  }

  void stop() {
    _isPlaying = false;
    notifyListeners();
  }

  void initialize(List<Part> parts) {
    this.parts.clear();
    this.parts.addAll(parts);
    notifyListeners();
  }

  Future<void> _playMeasure(Measure measure, int beatDurationMs) async {
    measure.isPlaying = true;
    for (int j = 0; j < measure.playableElements.length; j++) {
      if (!_isPlaying) break;
      playingElementIndex = j;
      final PlayableMusicElement element = measure.playableElements[j];
      element.play();
      notifyListeners();
      final durationMs = element.duration * beatDurationMs;
      await Future.delayed(Duration(milliseconds: durationMs.round()));
      element.stop();
      notifyListeners();
    }
    measure.isPlaying = false;
    notifyListeners();
  }

  void updateBpm(int bpm) {
    if (bpm < 20 || bpm > 240) {
      throw RangeError.range(bpm, 20, 240, 'BPM must be between 20 and 240');
    }
    _currentBpm = bpm;
    notifyListeners();
  }
}
