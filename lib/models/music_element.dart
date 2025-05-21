import 'package:sol/models/music_element_types.dart';

class MusicElement {
  final double measureOffset;
  final String type;
  final String? representation;
  final int? pitch;
  final String? name;
  final double? duration;
  final String? durationType;
  final String? value;

  MusicElement({
    required this.measureOffset,
    required this.type,
    this.representation,
    this.pitch,
    this.name,
    this.duration,
    this.durationType,
    this.value,
  });

  factory MusicElement.fromJson(Map<String, dynamic> json) => MusicElement(
        measureOffset: json['measureOffset']?.toDouble(),
        type: json['type'],
        representation: json['representation'],
        pitch: json['pitch'],
        name: json['name'],
        duration: json['duration']?.toDouble(),
        durationType: json['durationType'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'measureOffset': measureOffset,
        'type': type,
        'representation': representation,
        'pitch': pitch,
        'name': name,
        'duration': duration,
        'durationType': durationType,
        'value': value,
      };
  @override
  String toString() {
    switch (type) {
      case MusicElementTypes.note:
      return name ?? type;
      case MusicElementTypes.rest:
      return '$type$duration';
      case MusicElementTypes.chord:
      return 'Chord: $name';
      case MusicElementTypes.clef:
      return value ?? representation ?? 'Clef';
      case MusicElementTypes.timeSignature:
      return value ?? representation ?? 'Time Signature';
      case MusicElementTypes.keySignature:
      return value ?? representation ?? 'Key Signature';
      default:
      return type;
    }
  }
}
