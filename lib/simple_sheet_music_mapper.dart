import 'package:simple_sheet_music/simple_sheet_music.dart';

class SimpleSheetMusicMapper {
  static Pitch toPitch(int midiNumber) {
    return Pitch.values.firstWhere(
      (pitch) => pitch.position == midiNumber,
      orElse: () => Pitch.a0, // Default to A0 if not found
    );
  }

  static NoteDuration durationToNoteDuration(double duration) {
    switch (duration) {
      case 1.0:
        return NoteDuration.quarter;
      case 0.5:
        return NoteDuration.eighth;
      case 2.0:
        return NoteDuration.half;
      case 4.0:
        return NoteDuration.whole;
      default:
        return NoteDuration.quarter; // Default to quarter if unknown
    }
  }

  static RestType durationToRestType(double duration) {
    switch (duration) {
      case 1.0:
        return RestType.quarter;
      case 0.5:
        return RestType.eighth;
      case 2.0:
        return RestType.half;
      case 4.0:
        return RestType.whole;
      default:
        return RestType.quarter; // Default to quarter if unknown
    }
  }

  static ChordNotePart midiNumberToChordNotePart(int pitch) {
    return ChordNotePart(
      toPitch(pitch),
    );
  }

  static ChordNotePart pitchToChordNotePart(Pitch pitch) {
    return ChordNotePart(
      pitch,
    );
  }
}
