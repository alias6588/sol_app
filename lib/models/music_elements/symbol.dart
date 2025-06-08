import 'package:sol/models/music_elements/abstracts/musice_element.dart';

class Symbol extends MusicElement {
  Symbol(super.type, super.value, super.representation, super.measureOffset);

  static Symbol fromJson(Map<String, dynamic> json) {
    try {
      return Symbol(
        json['type'],
        json['value'],
        json['representation'],
        json['measureOffset']?.toDouble(),
      );
    } catch (e) {
      // Handle or log the error as needed
      throw FormatException('Invalid Symbol JSON: $e');
    }
  }

  @override
  String toString() => value ?? representation ?? type;
}
