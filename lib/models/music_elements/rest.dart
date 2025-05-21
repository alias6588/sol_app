import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class Rest extends PlayableMusicElement {
  Rest(super.type, super.value, super.representation, super.measureOffset,
      super.pitch, super.duration, super.durationType, super.name);

  @override
  get name => 'Rest';

  static Rest fromJson(Map<String, dynamic> json) => Rest(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset']?.toDouble(),
        json['pitch'],
        json['duration']?.toDouble(),
        json['durationType'],
        json['name'],
      );
}
