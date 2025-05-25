import "package:sol/models/music_elements/abstracts/musice_element.dart";
import "package:sol/models/music_elements/abstracts/playable_music_element.dart";

class Measure {
  final int measureNumber;
  final List<MusicElement> elements;

  var isPlaying = false;

  List<MusicElement> get cleanElements =>
      elements.where((e) => e.type != "Other").toList();
  List<PlayableMusicElement> get playableElements =>
      elements.whereType<PlayableMusicElement>().toList();

  Measure({required this.measureNumber, required this.elements});

  factory Measure.fromJson(Map<String, dynamic> json) => Measure(
        measureNumber: json['measure_number'],
        elements: List<MusicElement>.from(
            json['elements'].map((x) => MusicElement.fromJson(x))),
      );
}
