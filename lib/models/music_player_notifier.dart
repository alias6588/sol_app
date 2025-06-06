import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/midi_player.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class MusicPlayNotifier extends ChangeNotifier {
  final List<Measure> measures;
  int measureIndex = 0;
  int playingElementIndex = 0;
  bool _isPlaying = false;

  MusicPlayNotifier({required this.measures});

  bool get isPlaying => _isPlaying;

  MidiPlayer get midiPlayer => MidiPlayer();

  

  Future<void> play({required int bpm}) async {
    await midiPlayer.loadSoundfont();
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();

    final beatDurationMs = (60000 / bpm).round();

    for (int i = 0; i < measures.length; i++) {
      final measure = measures[i];
      measureIndex = i;
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

  getElement({required int measureIndex, required int elementIndex}) {
    if (measureIndex < 0 || measureIndex >= measures.length) {
      throw RangeError('Measure index out of range');
    }
    final measure = measures[measureIndex];
    if (elementIndex < 0 || elementIndex >= measure.playableElements.length) {
      throw RangeError('Element index out of range');
    }
    return measure.playableElements[elementIndex];
  }
}
