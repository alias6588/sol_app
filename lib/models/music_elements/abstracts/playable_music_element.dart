import 'package:flutter/foundation.dart';
import 'package:sol/models/music_elements/abstracts/musice_element.dart';

abstract class PlayableMusicElement extends MusicElement {
  final int? pitch;
  final double duration;
  final String durationType;
  final String name;
  bool isPlaying = false;

  PlayableMusicElement(
      super.type,
      super.value,
      super.representation,
      super.measureOffset,
      this.pitch,
      this.duration,
      this.durationType,
      this.name);

  void play() {
    isPlaying = true;
    if (kDebugMode) {
      final now = DateTime.now();
      print(
        '[${now.toIso8601String().split('T')[1]}] Playing note: $name, Pitch: $pitch, Duration: $duration'
      );
    }
  }

  void stop() {
    isPlaying = false;
    if (kDebugMode) {
      final now = DateTime.now();
      print('[${now.toIso8601String().split('T')[1]}] Stopping note: $name, Pitch: $pitch');
    }
  }

  @override
  String toString() => name;
}
