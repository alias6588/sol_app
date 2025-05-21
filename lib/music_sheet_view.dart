// import 'package:flutter/material.dart';
// import 'models/note_event.dart'; // Import the NoteEvent class
// import 'dart:math' as math; // Import math for calculations

// class MusicSheetView extends StatefulWidget {
//   final List<NoteEvent> noteEvents;
//   final int currentlyPlayingIndex;

//   MusicSheetView(
//       {required this.noteEvents, required this.currentlyPlayingIndex});

//   @override
//   _MusicSheetViewState createState() => _MusicSheetViewState();
// }

// class _MusicSheetViewState extends State<MusicSheetView> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: MusicSheetPainter(
//         noteEvents: widget.noteEvents,
//         currentlyPlayingIndex: widget.currentlyPlayingIndex,
//       ),
//       size: Size.infinite, // Allow the painter to fill the available space
//     );
//   }
// }

// class MusicSheetPainter extends CustomPainter {
//   final List<NoteEvent> noteEvents;
//   final int currentlyPlayingIndex;

//   MusicSheetPainter(
//       {required this.noteEvents, required this.currentlyPlayingIndex});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double staffLineSpacing = 10.0; // Spacing between staff lines
//     final double staffLineThickness = 1.0; // Thickness of staff lines
//     final double noteRadius = 5.0; // Radius of the note head
//     final double noteStemLength = 20.0; // Length of the note stem
//     final double noteHorizontalSpacing = 30.0; // Horizontal space between notes

//     final Paint linePaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = staffLineThickness;

//     final Paint notePaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;

//     final Paint playingNotePaint = Paint()
//       ..color = Colors.yellow // Color for the currently playing note
//       ..style = PaintingStyle.fill;

//     // Draw the staff lines (simplified for demonstration - only one staff)
//     final double staffTop = size.height / 2 - (staffLineSpacing * 2);
//     for (int i = 0; i < 5; i++) {
//       final double y = staffTop + i * staffLineSpacing;
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
//     }

//     // Draw notes
//     for (int i = 0; i < noteEvents.length; i++) {
//       final noteEvent = noteEvents[i];
//       final bool isPlaying = i == currentlyPlayingIndex;

//       // Simplified positioning based on index and a base line (e.g., middle C)
//       // This is a very basic representation and doesn't account for clefs,
//       // ledger lines, or complex rhythmic notation.
//       // A real music sheet renderer would require more complex logic.

//       // For simplicity, let's just space them horizontally and use pitch for vertical position.
//       // This will NOT look like actual sheet music but will show note highlighting.

//       final double x = 50.0 + i * noteHorizontalSpacing; // Horizontal position

//       if (noteEvent.type == 'note') {
//         final int pitch = noteEvent.pitch!;
//         // Basic vertical positioning (higher pitch = higher position)
//         // This needs proper mapping to staff lines based on clef.
//         // For now, a simple linear mapping for demonstration:
//         final double y = size.height / 2 -
//             (pitch - 60) *
//                 (staffLineSpacing /
//                     2); // Adjust 60 based on your desired middle C position

//         // Draw note head
//         canvas.drawCircle(
//             Offset(x, y), noteRadius, isPlaying ? playingNotePaint : notePaint);

//         // Draw stem (simplified - always points up)
//         canvas.drawLine(
//             Offset(x + noteRadius, y),
//             Offset(x + noteRadius, y - noteStemLength),
//             isPlaying ? playingNotePaint : notePaint);
//       } else if (noteEvent.type == 'chord') {
//         final List<int> pitches = noteEvent.pitches!;
//         for (var pitch in pitches) {
//           // Basic vertical positioning for chord notes
//           final double y = size.height / 2 -
//               (pitch - 60) * (staffLineSpacing / 2); // Adjust 60

//           // Draw note head
//           canvas.drawCircle(Offset(x, y), noteRadius,
//               isPlaying ? playingNotePaint : notePaint);
//         }
//         // Draw a single stem for the chord (simplified)
//         if (pitches.isNotEmpty) {
//           final lowestPitchY = size.height / 2 -
//               (pitches.reduce(math.max) - 60) *
//                   (staffLineSpacing / 2); // Stem from highest note
//           canvas.drawLine(
//               Offset(x + noteRadius, lowestPitchY),
//               Offset(x + noteRadius, lowestPitchY - noteStemLength),
//               isPlaying ? playingNotePaint : notePaint);
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // Repaint when the currently playing index changes
//     return (oldDelegate as MusicSheetPainter).currentlyPlayingIndex !=
//         currentlyPlayingIndex;
//   }
// }
