// import 'package:flutter/material.dart';
// import 'package:flutter_midi_pro/flutter_midi_pro.dart'; // Import flutter_midi_pro
// import 'package:flutter/services.dart'
//     show rootBundle; // For loading assets (soundfont)
// import 'package:sol/models/measure.dart';
// import 'models/note_event.dart'; // Import the NoteEvent class
// import 'music_sheet_view.dart'; // Import the custom music sheet view - Ensure this file exists and is correct

// class MusicPlayerScreen extends StatefulWidget {
//   // Receive the list of NoteEvent objects
//   final List<Measure> measures;

//   MusicPlayerScreen({required this.measures});

//   @override
//   _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
//   // --- State Variables ---
//   double _currentTempo = 120.0; // Default Tempo (BPM)
//   bool _isLoadingSoundfont = true; // Track soundfont loading state
//   String _statusMessage =
//       'در حال بارگذاری SoundFont...'; // Loading SoundFont...
//   // Use FlutterMidiPro instead of FlutterMidi
//   final _flutterMidiPro = MidiPro();

//   // Variable to store the Soundfont ID
//   int? _soundfontId;

//   // Variable to track the index of the currently playing note event
//   int _currentlyPlayingIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     _loadSoundfont(); // Load SoundFont on startup
//   }

//   // --- Load SoundFont ---
//   Future<void> _loadSoundfont() async {
//     setState(() {
//       _statusMessage = "در حال بارگذاری SoundFont..."; // Loading SoundFont...
//       _isLoadingSoundfont = true;
//     });
//     try {
//       // Ensure the path to the sf2 file in assets and pubspec.yaml is correct
//       final sf2Path =
//           "assets/soundfonts/GeneralUser-GS.sf2"; // Put your file name here

//       // Load the soundfont using flutter_midi_pro
//       // flutter_midi_pro's loadSoundfont takes the asset path directly
//       // It returns the sfId (Soundfont ID) which we need to store.
//       // You can optionally specify bank and program here if you want a specific instrument loaded initially.
//       // If not specified, it usually defaults to bank 0, program 0 (often a piano).
//       // Replace 0 and 0 with the desired bank and program numbers from your soundfont documentation.
//       // Example: To load Acoustic Grand Piano (Program 0, Bank 0 in GM):
//       _soundfontId = await _flutterMidiPro.loadSoundfont(
//           path: sf2Path, bank: 0, program: 0);

//       // If you don't specify bank/program, it uses default (usually bank 0, program 0):
//       // _soundfontId = await _flutterMidiPro.loadSoundfont(sf2Path);

//       print("SoundFont loaded successfully with ID: $_soundfontId");
//       setState(() {
//         _statusMessage =
//             "SoundFont با موفقیت بارگذاری شد. آماده پخش."; // SoundFont loaded successfully. Ready to play.
//         _isLoadingSoundfont = false;
//       });
//     } catch (e) {
//       print("Error loading Soundfont: $e");
//       setState(() {
//         _statusMessage =
//             "خطا در بارگذاری SoundFont: $e"; // Error loading SoundFont: $e
//         _isLoadingSoundfont = false;
//         _soundfontId = null; // Clear sfId on error
//       });
//       // Show error to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'خطا در بارگذاری SoundFont: $e')), // Error loading SoundFont: $e
//       );
//     }
//   }

//   // --- Play Music ---
//   Future<void> _playMusic() async {
//     // Ensure soundfont is loaded and notes data is available
//     if (_soundfontId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'SoundFont هنوز بارگذاری نشده است. لطفاً صبر کنید.')), // SoundFont is not loaded yet. Please wait.
//       );
//       return;
//     }
//     if (widget.measures.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'داده‌ای برای پخش وجود ندارد. لطفاً اول فایل را پردازش کنید.')), // No data to play. Please process the file first.
//       );
//       return;
//     }
//     if (_isLoadingSoundfont) {
//       // Prevent playing while Soundfont is loading
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'لطفاً تا پایان بارگذاری SoundFont صبر کنید.')), // Please wait until the SoundFont is loaded.
//       );
//       return;
//     }

//     // Reset playing state for all notes before starting
//     for (var measure in widget.measures) {
//       measure.isPlaying = false;
//     }
//     setState(() {
//       _statusMessage = 'در حال پخش...'; // Playing...
//       _currentlyPlayingIndex = -1; // Reset playing index
//     });

//     // Calculate the duration of a quarter note in seconds
//     double quarterNoteDurationSec = 60.0 / _currentTempo;
//     print(
//         "Playing with tempo: $_currentTempo BPM (Quarter note: ${quarterNoteDurationSec.toStringAsFixed(3)} sec)");

//     // Schedule the playback of each note/chord
//     for (int i = 0; i < widget.measures.length; i++) {
//       final measure = widget.measures[i];
//       final startTimeMs =
//           (measure.offset * quarterNoteDurationSec * 1000).round();
//       final durationMs =
//           (measure.duration * quarterNoteDurationSec * 1000).round();

//       // Schedule the start of the note/chord
//       Future.delayed(Duration(milliseconds: startTimeMs), () {
//         if (!mounted)
//           return; // Don't execute if the widget has been removed from the tree

//         setState(() {
//           // Update the currently playing index
//           _currentlyPlayingIndex = i;
//           // Set the isPlaying flag for the current event
//           measure.isPlaying = true;
//         });

//         print('Note On: ${measure.displayString} at $startTimeMs ms');
//         // Play the note(s)
//         if (measure.type == 'note') {
//           _flutterMidiPro.playNote(
//               key: measure.pitch!, sfId: _soundfontId!, velocity: 127);
//         } else if (measure.type == 'chord') {
//           for (var pitch in measure.pitches!) {
//             _flutterMidiPro.playNote(
//                 key: pitch, sfId: _soundfontId!, velocity: 127);
//           }
//         }

//         // Schedule the end of the note/chord
//         Future.delayed(Duration(milliseconds: durationMs), () {
//           if (!mounted) return;

//           print('Note Off: ${measure.displayString} after $durationMs ms');
//           // Stop the note(s)
//           if (measure.type == 'note') {
//             _flutterMidiPro.stopNote(
//                 key: measure.pitch!, sfId: _soundfontId!);
//           } else if (measure.type == 'chord') {
//             for (var pitch in measure.pitches!) {
//               _flutterMidiPro.stopNote(key: pitch, sfId: _soundfontId!);
//             }
//           }

//           setState(() {
//             // Reset the isPlaying flag for the current event
//             measure.isPlaying = false;
//             // If this was the last note, reset the playing index
//             if (i == widget.noteEvents.length - 1) {
//               _currentlyPlayingIndex = -1;
//               _statusMessage = 'پخش تمام شد.'; // Playback finished.
//             }
//           });
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('پخش کننده نت موسیقی'), // Music Sheet Player
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // --- Music Sheet Display Area ---
//               Expanded(
//                 child: MusicSheetView(
//                   noteEvents: widget.noteEvents,
//                   currentlyPlayingIndex: _currentlyPlayingIndex,
//                 ),
//               ),
//               SizedBox(height: 20),

//               // --- Tempo Slider ---
//               Text('تمپو: ${_currentTempo.round()} BPM',
//                   style: TextStyle(fontSize: 16)), // Tempo:
//               Slider(
//                 value: _currentTempo,
//                 min: 30.0,
//                 max: 240.0,
//                 divisions: (240 - 30), // Number of divisions
//                 label: _currentTempo.round().toString(),
//                 onChanged:
//                     (_isLoadingSoundfont) // Disable if soundfont is loading
//                         ? null
//                         : (newTempo) {
//                             setState(() {
//                               _currentTempo = newTempo;
//                             });
//                           },
//               ),
//               SizedBox(height: 20),

//               // --- Play Button ---
//               ElevatedButton.icon(
//                 icon: Icon(Icons.play_arrow),
//                 label: Text('پخش موسیقی'), // Play Music
//                 onPressed: (widget.noteEvents.isEmpty ||
//                         _isLoadingSoundfont ||
//                         _soundfontId == null)
//                     ? null
//                     : _playMusic, // Disable if no data, loading, or soundfont not loaded
//               ),
//               SizedBox(height: 10),
//               if (_isLoadingSoundfont) CircularProgressIndicator(),
//               SizedBox(height: 10),
//               Text(
//                 _statusMessage,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: _statusMessage.contains("خطا")
//                         ? Colors.red
//                         : Colors.black), // Error
//                 textDirection: TextDirection.rtl, // For Persian messages
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose the midi pro instance when the widget is disposed
//     _flutterMidiPro.dispose();
//     super.dispose();
//   }
// }
