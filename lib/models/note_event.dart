// Custom class to represent a musical event (note or chord)
class NoteEvent {
  final String type; // 'note' or 'chord'
  final double offset; // Start time in quarter notes
  final double duration; // Duration in quarter notes
  final int? pitch; // MIDI pitch for single notes
  final List<int>? pitches; // MIDI pitches for chords
  bool isPlaying; // Flag to indicate if this note/chord is currently playing

  NoteEvent({
    required this.type,
    required this.offset,
    required this.duration,
    this.pitch,
    this.pitches,
    this.isPlaying = false,
  });

  // Factory method to create a NoteEvent from JSON data
  factory NoteEvent.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'note') {
      return NoteEvent(
        type: json['type'],
        offset: json['offset'].toDouble(),
        duration: json['duration'].toDouble(),
        pitch: json['pitch'] as int,
      );
    } else if (json['type'] == 'chord') {
      return NoteEvent(
        type: json['type'],
        offset: json['offset'].toDouble(),
        duration: json['duration'].toDouble(),
        pitches: List<int>.from(json['pitches']),
      );
    }
    // Handle unknown types or throw an error
    throw Exception('Unknown note type: ${json['type']}');
  }

  // Helper to get a string representation of the note(s)
  String get displayString {
    if (type == 'note') {
      return 'Note: $pitch';
    } else if (type == 'chord') {
      return 'Chord: ${pitches!.join(', ')}';
    }
    return 'Unknown';
  }
}
