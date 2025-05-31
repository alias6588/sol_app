import 'package:flutter_midi_pro/flutter_midi_pro.dart'; // Import flutter_midi_pro
import 'package:sol/exceptions/not_found_sound_font_id.dart';
import 'package:sol/exceptions/sound_font_loading.dart';

class MidiPlayer {
  // --- Singleton Implementation ---
  static final MidiPlayer _instance = MidiPlayer._internal();

  factory MidiPlayer() {
    return _instance;
  }

  MidiPlayer._internal();

  final _flutterMidiPro = MidiPro();

  // Variable to store the Soundfont ID
  int? _soundfontId;

  // Variable to track the index of the currently playing note event

  // --- Load SoundFont ---
  Future<void> loadSoundfont() async {
    if (_soundfontId != null) {
      // If soundfont is already loaded, no need to load it again
      return;
    }
    try {
      // Ensure the path to the sf2 file in assets and pubspec.yaml is correct
      final sf2Path =
          "assets/soundfonts/GeneralUser-GS.sf2"; // Put your file name here

      _soundfontId = await _flutterMidiPro.loadSoundfont(
          path: sf2Path, bank: 0, program: 0);
    } catch (e) {
      // Show error to the user
      throw SoundFontLoadingException(e.toString());
    }
  }

  /// Plays a single note with the given pitch.
  Future<void> playNote(int pitch, {int velocity = 127}) async {
    if (_soundfontId == null) {
      throw NotFoundSoundFontIdException('شناسه فونت صدا یافت نشد.');
    }
    await _flutterMidiPro.playNote(
      key: pitch,
      sfId: _soundfontId!,
      velocity: velocity,
    );
  }

  /// Stops a single note with the given pitch.
  Future<void> stopNote(int pitch) async {
    if (_soundfontId == null) {
      throw NotFoundSoundFontIdException('شناسه فونت صدا یافت نشد.');
    }
    await _flutterMidiPro.stopNote(
      key: pitch,
      sfId: _soundfontId!,
    );
  }

  /// Plays a chord (multiple pitches) at once.
  Future<void> playChord(List<int> pitches, {int velocity = 127}) async {
    if (_soundfontId == null) {
      throw NotFoundSoundFontIdException('شناسه فونت صدا یافت نشد.');
    }
    for (final pitch in pitches) {
      await _flutterMidiPro.playNote(
        key: pitch,
        sfId: _soundfontId!,
        velocity: velocity,
      );
    }
  }

  /// Stops a chord (multiple pitches) at once.
  Future<void> stopChord(List<int> pitches) async {
    if (_soundfontId == null) {
      throw NotFoundSoundFontIdException('شناسه فونت صدا یافت نشد.');
    }
    for (final pitch in pitches) {
      await _flutterMidiPro.stopNote(
        key: pitch,
        sfId: _soundfontId!,
      );
    }
  }
}
