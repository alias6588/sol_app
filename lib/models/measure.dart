import "music_element.dart";

class Measure {
  final int measureNumber;
  final List<MusicElement> elements;

  List<MusicElement> get cleanElements =>
    elements.where((e) => e.type != "Other").toList();

  Measure({required this.measureNumber, required this.elements});

  factory Measure.fromJson(Map<String, dynamic> json) => Measure(
        measureNumber: json['measure_number'],
        elements: List<MusicElement>.from(
            json['elements'].map((x) => MusicElement.fromJson(x))),
      );

  set isPlaying(bool isPlaying) {}

  Map<String, dynamic> toJson() => {
        'measure_number': measureNumber,
        'elements': List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}
