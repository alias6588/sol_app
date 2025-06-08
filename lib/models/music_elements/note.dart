import 'package:sol/models/midi_player.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class Note extends PlayableMusicElement {
  Note(super.type, super.value, super.representation, super.measureOffset,
      super.pitch, super.duration, super.durationType, super.name);

  MidiPlayer get midiPlayer => MidiPlayer();

  @override
  play() {
    super.play();
    midiPlayer.playNote(pitch!.toInt());
  }

  @override
  stop() {
    super.stop();
    midiPlayer.stopNote(pitch!.toInt());
  }

  static Note fromJson(Map<String, dynamic> json) {
    try {
      return Note(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset'].toDouble(),
        json['pitch'],
        json['duration'].toDouble(),
        json['durationType'],
        json['name'],
      );
    } catch (e) {
      // Handle or rethrow as needed
      throw FormatException('Invalid Note JSON: $e');
    }
  }
}
