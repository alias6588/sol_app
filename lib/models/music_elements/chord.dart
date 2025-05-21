import 'package:sol/models/music_elements/abstracts/musice_element.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class Chord extends PlayableMusicElement {
  final List<String> notes;

  Chord(super.type, super.value, super.representation, super.measureOffset,
      super.pitch, super.duration, super.durationType, super.name, this.notes);

  static MusicElement fromJson(Map<String, dynamic> json) => Chord(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset']?.toDouble(),
        json['pitch'],
        json['duration']?.toDouble(),
        json['durationType'],
        json['name'],
        List<String>.from(json['notes']),
      );
}
