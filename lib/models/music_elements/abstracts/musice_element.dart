import 'package:sol/models/music_element_types.dart';
import 'package:sol/models/music_elements/chord.dart';
import 'package:sol/models/music_elements/note.dart';
import 'package:sol/models/music_elements/rest.dart';
import 'package:sol/models/music_elements/symbol.dart';

abstract class MusicElement {
  final double? measureOffset;
  final String type;
  final String? value;
  final String? representation;

  MusicElement(this.type, this.value, this.representation, this.measureOffset);
  factory MusicElement.fromJson(Map<String, dynamic> json) {
    var type = json['type']?.toString().toLowerCase();
    switch (type) {
      case MusicElementTypes.note:
        return Note.fromJson(json);
      case MusicElementTypes.rest:
        return Rest.fromJson(json);
      case MusicElementTypes.chord:
        return Chord.fromJson(json);
      case MusicElementTypes.clef:
      case MusicElementTypes.timeSignature:
      case MusicElementTypes.keySignature:
      case MusicElementTypes.other:
        return Symbol.fromJson(json);
      default:
        throw Exception('Unknown type: ${type}');
    }
  }
}
