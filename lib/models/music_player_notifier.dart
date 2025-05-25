import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class MusicPlayNotifier extends ChangeNotifier {
  final List<Measure> measures;
  bool _isPlaying = false;

  MusicPlayNotifier({required this.measures});

  bool get isPlaying => _isPlaying;

  Future<void> play({required int bpm}) async {
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();

    final beatDurationMs = (60000 / bpm).round();

    for (final measure in measures) {
      measure.isPlaying = true;
      notifyListeners();
      for (final PlayableMusicElement element in measure.playableElements) {
        if (!_isPlaying) break;
        element.play();
        final durationMs = element.duration * beatDurationMs;
        await Future.delayed(Duration(milliseconds: durationMs.round()));
        element.stop();
      }
      measure.isPlaying = false;
      notifyListeners();
      if (!_isPlaying) break;
    }

    stop();
  }

  void stop() {
    _isPlaying = false;
    notifyListeners();
  }

  void initialize(List<Measure> measures) {
    this.measures.clear();
    this.measures.addAll(measures);
    notifyListeners();  
  }
}
