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
  }

  void stop() {
    isPlaying = false;
  }

  @override
  String toString() => name;
}
