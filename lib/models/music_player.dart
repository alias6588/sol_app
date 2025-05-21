import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class MusicPlayer extends ChangeNotifier {
  final List<Measure> measures;
  Timer? _timer;
  bool _isPlaying = false;

  MusicPlayer({required this.measures});

  bool get isPlaying => _isPlaying;

  Future<void> play({required int bpm}) async {
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();

    final beatDurationMs = (60000 / bpm).round();

    for (final measure in measures) {
      for (final PlayableMusicElement element in measure.playableElements) {
        if (!_isPlaying) break;
        element.play();
        final duration =
            element.duration! > 0 ? element.duration! : beatDurationMs;
        await Future.delayed(Duration(milliseconds: duration.round()));
        element.stop();
      }
      if (!_isPlaying) break;
    }

    _isPlaying = false;
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }
}
