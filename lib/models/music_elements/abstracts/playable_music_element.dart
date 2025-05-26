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
    print('Playing note: $name for $duration');
    isPlaying = true;
  }
  
  void stop() {
    print('stoped note: $name');
    isPlaying = false;
  }

  @override
  String toString() => name;
}
