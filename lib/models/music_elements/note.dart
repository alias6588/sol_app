import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class Note extends PlayableMusicElement {
  Note(super.type, super.value, super.representation, super.measureOffset,
      super.pitch, super.duration, super.durationType, super.name);

  static Note fromJson(Map<String, dynamic> json) => Note(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset'].toDouble(),
        json['pitch'],
        json['duration'].toDouble(),
        json['durationType'],
        json['name'],
      );
}
