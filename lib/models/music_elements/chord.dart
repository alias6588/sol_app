import 'package:sol/models/midi_player.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class Chord extends PlayableMusicElement {
  final String pitchedCommonName;
  final List<String> names;
  final List<int> pitches;

  Chord(super.type, super.value, super.representation, super.measureOffset,
      super.pitch, super.duration, super.durationType, super.name,
      {required this.pitchedCommonName,
      required this.names,
      required this.pitches});

  MidiPlayer get midiPlayer => MidiPlayer();

  @override
  void play() {
    midiPlayer.playChord(pitches);
  }

  @override
  void stop() {
    midiPlayer.stopChord(pitches);
  }

  factory Chord.fromJson(Map<String, dynamic> json) {
    try {
      return Chord(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset'].toDouble(),
        json['pitch'],
        json['duration'].toDouble(),
        json['durationType'],
        json['name'] ??
            json['names']?.reduce((a, b) => '$a$b') ??
            json['pitched_common_name'] ??
            '',
        pitchedCommonName: json['pitched_common_name'] as String? ?? '',
        names: (json['names'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        pitches: (json['pitches'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
      );
    } catch (e) {
      throw FormatException('Failed to parse Chord from JSON: $e');
    }
  }
}
