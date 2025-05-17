import 'package:flutter/material.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart'; // Import the library and its core types
import 'package:simple_sheet_music/src/music_objects/interface/musical_symbol.dart';
import 'package:sol/simple_sheet_music_mapper.dart';
import 'note_event.dart'; // Import your NoteEvent class

class MusicSheetView extends StatefulWidget {
  final List<NoteEvent> noteEvents;
  // final int currentlyPlayingIndex;

  MusicSheetView(
      {required this.noteEvents});

  @override
  _MusicSheetViewState createState() => _MusicSheetViewState();
}

class _MusicSheetViewState extends State<MusicSheetView> {
  // Convert your NoteEvent data to the format required by simple_sheet_music
  // Using 'MusicalElement' as the base type, which is defined in the simple_sheet_music library.
  List<MusicalSymbol> _convertToSimpleSheetMusicData(List<NoteEvent> events) {
    final List<MusicalSymbol> musicList = [];
    
    for (int i = 0; i < events.length; i++) {
      final event = events[i];

      NoteDuration durationValue =
          SimpleSheetMusicMapper.durationToNoteDuration(event.duration);

      if (event.type == 'note') {
        // simple_sheet_music uses Pitch for note pitches.
        // The Pitch class provides a factory constructor `fromMidiNumber`
        // to convert a MIDI pitch integer to a Pitch object.
        try {
          final pitch = SimpleSheetMusicMapper.toPitch(event.pitch!);
          musicList.add(
            Note(
              pitch, // Get the Pitch object
              noteDuration: durationValue,
            ),
          );
        } catch (e) {
          print("Error converting MIDI pitch ${event.pitch} to Pitch: $e");
          // If pitch conversion fails, add a rest instead of the note.
          musicList.add(Rest(RestType.eighth,
              color: Colors.black, margin: EdgeInsets.all(10)));
        }
      } else if (event.type == 'chord') {
        final List<ChordNotePart> chordPitches = [];
        bool conversionFailed = false;
        for (var pitch in event.pitches!) {
          try {
            // Convert each pitch in the chord using Pitch.fromMidiNumber
            chordPitches
                .add(SimpleSheetMusicMapper.midiNumberToChordNotePart(pitch));
          } catch (e) {
            print("Error converting MIDI pitch $pitch in chord to Pitch: $e");
            conversionFailed = true;
            break; // Stop processing this chord if any pitch fails
          }
        }
        if (!conversionFailed && chordPitches.isNotEmpty) {
          musicList.add(
            ChordNote(
              chordPitches,
              noteDuration: durationValue,
            ),
          );
        } else if (conversionFailed) {
          // Add a rest if chord conversion failed
          musicList.add(Rest(
              SimpleSheetMusicMapper.durationToRestType(event.duration),
              color: Colors.black,
              margin: EdgeInsets.all(10)));
        }
      }
      // Note: simple_sheet_music lays out elements sequentially.
      // The 'offset' property from your NoteEvent is not used for visual positioning
      // on the sheet by this library.
    }

    return musicList;
  }

  @override
  Widget build(BuildContext context) {
    // Convert the NoteEvent list to the format required by simple_sheet_music
    final simpleMusicData = _convertToSimpleSheetMusicData(widget.noteEvents);

    // simple_sheet_music renders the music notation using the SheetMusic widget.
    // It takes a list of MusicalElement objects.
    // Highlighting the currently playing note is NOT a built-in feature
    // of simple_sheet_music version 1.0.1.
    // The `currentlyPlayingIndex` is not used by the SheetMusic widget itself.
    // We would need a custom solution or a different library for direct highlighting on the sheet.
    // For now, this will just display the static sheet music based on the notes.
    final measure1 = Measure([
      const Clef(ClefType.treble),
      const KeySignature(
        KeySignatureType.cMajor,
      ),
      
      ...simpleMusicData,
      
    ]);
    // final measure2 = Measure([
    //   const ChordNote([
    //     ChordNotePart(Pitch.c4),
    //     ChordNotePart(Pitch.c5),
    //   ], noteDuration: NoteDuration.sixteenth),
    //   const Note(Pitch.a4,
    //       noteDuration: NoteDuration.sixteenth, accidental: Accidental.flat)
    // ]);
    // final measure3 = Measure(
    //   [
    //     const Clef(ClefType.treble),
    //     const KeySignature(
    //       KeySignatureType.cMajor,
    //     ),
    //     const ChordNote(
    //       [
    //         ChordNotePart(Pitch.c2),
    //         ChordNotePart(Pitch.c3),
    //       ],
    //     ),
    //     const Rest(RestType.quarter),
    //     const Note(Pitch.a3,
    //         noteDuration: NoteDuration.whole, accidental: Accidental.flat),
    //   ],
    //   isNewLine: true,
    // );
    return SingleChildScrollView(
      scrollDirection:
          Axis.horizontal, // Allow horizontal scrolling for wider music
      child: SimpleSheetMusic(
        measures: [
          measure1,
        ], // Pass the list of MusicalElement objects
        // You can customize clef, key signature, time signature, etc. here
        initialClefType: ClefType.treble, // Example: Set to Treble clef
        // keySignature: KeySignature.cMajor, // Example: C Major
        // timeSignature: TimeSignature(4, 4), // Example: 4/4 time
        // You might need to derive these from your backend data if available
      ),
    );
  }
}

