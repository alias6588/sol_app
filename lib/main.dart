import 'dart:convert'; // For jsonDecode
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:flutter_midi_pro/flutter_midi_pro.dart'; // Import flutter_midi_pro
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:path/path.dart' as p; // For getting basename

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'پخش کننده نت موسیقی', // Music Sheet Player
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  // --- State Variables ---
  File? _selectedFile;
  List<Map<String, dynamic>>? _notesData;
  double _currentTempo = 120.0; // Default Tempo (BPM)
  bool _isLoading = false;
  String _statusMessage =
      'لطفاً یک فایل نت موسیقی انتخاب کنید.'; // Please select a music sheet file.
  // Use FlutterMidiPro instead of FlutterMidi
  final _flutterMidiPro = MidiPro();

  // Variable to store the Soundfont ID
  int? _soundfontId;

  // If you are using a real device or iOS simulator, enter your computer's local IP (e.g., 192.168.1.100).
  final String _backendUrl = 'http://192.168.1.51:8000/upload/';

  @override
  void initState() {
    super.initState();
    _loadSoundfont(); // Load SoundFont on startup
  }

  // --- Load SoundFont ---
  Future<void> _loadSoundfont() async {
    setState(() {
      _statusMessage = "در حال بارگذاری SoundFont..."; // Loading SoundFont...
      _isLoading = true;
    });
    try {
      // Ensure the path to the sf2 file in assets and pubspec.yaml is correct
      final sf2Path =
          "assets/soundfonts/GeneralUser-GS.sf2"; // Put your file name here

      // Load the soundfont using flutter_midi_pro
      // flutter_midi_pro's loadSoundfont takes the asset path directly
      // It returns the sfid (Soundfont ID) which we need to store.
      // You can optionally specify bank and program here if you want a specific instrument loaded initially.
      // If not specified, it usually defaults to bank 0, program 0 (often a piano).
      // Replace 0 and 0 with the desired bank and program numbers from your soundfont documentation.
      // Example: To load Acoustic Grand Piano (Program 0, Bank 0 in GM):
      _soundfontId = await _flutterMidiPro.loadSoundfont(
          path: sf2Path, bank: 0, program: 0);

      // If you don't specify bank/program, it uses default (usually bank 0, program 0):
      // _soundfontId = await _flutterMidiPro.loadSoundfont(sf2Path);

      print("SoundFont loaded successfully with ID: $_soundfontId");
      setState(() {
        _statusMessage =
            "SoundFont با موفقیت بارگذاری شد. لطفاً فایل را انتخاب کنید."; // SoundFont loaded successfully. Please select a file.
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading Soundfont: $e");
      setState(() {
        _statusMessage =
            "خطا در بارگذاری SoundFont: $e"; // Error loading SoundFont: $e
        _isLoading = false;
        _soundfontId = null; // Clear sfid on error
      });
      // Show error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'خطا در بارگذاری SoundFont: $e')), // Error loading SoundFont: $e
      );
    }
  }

  // --- Pick and Upload File ---
  Future<void> _pickAndUploadFile() async {
    // Pick image file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Only image files
    );

    if (result != null && result.files.single.path != null) {
      _selectedFile = File(result.files.single.path!);
      _notesData = null; // Clear previous data
      setState(() {
        _isLoading = true;
        _statusMessage =
            'در حال آپلود و پردازش فایل...'; // Uploading and processing file...
      });

      try {
        // Build multipart request
        var request = http.MultipartRequest('POST', Uri.parse(_backendUrl));
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // Field name must match the one in FastAPI ('file')
            _selectedFile!.path,
            filename: p.basename(_selectedFile!.path), // Send file name
          ),
        );

        // Send request
        var streamedResponse = await request.send();

        // Receive response
        var response = await http.Response.fromStream(streamedResponse);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          // Processing was successful
          List<dynamic> decodedData = jsonDecode(response.body);
          // Convert List<dynamic> to List<Map<String, dynamic>>
          _notesData = List<Map<String, dynamic>>.from(decodedData);
          setState(() {
            _statusMessage =
                'پردازش کامل شد. آماده پخش.'; // Processing complete. Ready to play.
          });
          print("Received ${_notesData?.length} notes.");
        } else {
          // Server-side error
          print('Server Error: ${response.statusCode}');
          print('Server Response: ${response.body}');
          String errorMessage =
              'خطا در پردازش فایل در سرور.'; // Error processing file on server.
          try {
            // Try to read error details from the server response
            var errorJson = jsonDecode(response.body);
            if (errorJson is Map && errorJson.containsKey('detail')) {
              errorMessage = errorJson['detail'];
            }
          } catch (e) {
            // If the response was not JSON
            errorMessage += "\n${response.body}";
          }
          setState(() {
            _statusMessage = errorMessage;
            _notesData = null;
            _selectedFile = null; // Set file to null as it wasn't processed
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(errorMessage, textDirection: TextDirection.rtl)),
          );
        }
      } catch (e) {
        // Network or other errors
        print("Error uploading file: $e");
        setState(() {
          _isLoading = false;
          _statusMessage =
              'خطا در ارتباط با سرور: $e'; // Error communicating with server: $e
          _notesData = null;
          _selectedFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'خطا در ارتباط با سرور: $e')), // Error communicating with server: $e
        );
      }
    } else {
      // User cancelled file selection
      setState(() {
        _statusMessage = 'انتخاب فایل لغو شد.'; // File selection cancelled.
        _selectedFile = null;
        _notesData = null;
      });
    }
  }

  // --- Play Music ---
  Future<void> _playMusic() async {
    // Ensure soundfont is loaded and notes data is available
    if (_soundfontId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'SoundFont هنوز بارگذاری نشده است. لطفاً صبر کنید.')), // SoundFont is not loaded yet. Please wait.
      );
      return;
    }
    if (_notesData == null || _notesData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'داده‌ای برای پخش وجود ندارد. لطفاً اول فایل را پردازش کنید.')), // No data to play. Please process the file first.
      );
      return;
    }
    if (_isLoading) {
      // Prevent playing while SoundFont is loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'لطفاً تا پایان بارگذاری SoundFont صبر کنید.')), // Please wait until the SoundFont is loaded.
      );
      return;
    }

    setState(() {
      _statusMessage = 'در حال پخش...'; // Playing...
    });

    // Calculate the duration of a quarter note in seconds
    double quarterNoteDurationSec = 60.0 / _currentTempo;
    print(
        "Playing with tempo: $_currentTempo BPM (Quarter note: ${quarterNoteDurationSec.toStringAsFixed(3)} sec)");

    // To prevent simultaneous playback of previous notes if the Play button is pressed again
    // (This is a simple implementation, there are better ways to stop)
    // TODO: Implement a proper stop mechanism if needed

    // Schedule the playback of each note/chord
    for (var noteData in _notesData!) {
      final elementType = noteData['type'];
      final offset = noteData['offset']; // Start time (in quarter notes)
      final duration = noteData['duration']; // Duration (in quarter notes)

      // Calculate start time and duration in milliseconds
      final startTimeMs = (offset * quarterNoteDurationSec * 1000).round();
      final durationMs = (duration * quarterNoteDurationSec * 1000).round();

      if (elementType == 'note') {
        final pitch = noteData['pitch'] as int;
        // Schedule Note On
        Future.delayed(Duration(milliseconds: startTimeMs), () {
          if (!mounted)
            return; // Don't execute if the widget has been removed from the tree
          print('Note On: $pitch at $startTimeMs ms');
          // Use flutter_midi_pro's playNote with key, sfid, and velocity
          // Using pitch for key, stored _soundfontId for sfid, and a default velocity (e.g., 127)
          _flutterMidiPro.playNote(
              key: pitch, sfId: _soundfontId!, velocity: 127);

          // Schedule Note Off
          Future.delayed(Duration(milliseconds: durationMs), () {
            if (!mounted) return;
            print('Note Off: $pitch after $durationMs ms');
            // Use flutter_midi_pro's stopNote with key and sfid
            _flutterMidiPro.stopNote(key: pitch, sfId: _soundfontId!);
          });
        });
      } else if (elementType == 'chord') {
        final pitches = List<int>.from(noteData['pitches']);
        // Schedule Note On for chord
        Future.delayed(Duration(milliseconds: startTimeMs), () {
          if (!mounted) return;
          print('Chord On: $pitches at $startTimeMs ms');
          for (var pitch in pitches) {
            // Use flutter_midi_pro's playNote for each pitch in the chord
            _flutterMidiPro.playNote(
                key: pitch, sfId: _soundfontId!, velocity: 127);
          }
          // Schedule Note Off for chord
          Future.delayed(Duration(milliseconds: durationMs), () {
            if (!mounted) return;
            print('Chord Off: $pitches after $durationMs ms');
            for (var pitch in pitches) {
              // Use flutter_midi_pro's stopNote for each pitch in the chord
              _flutterMidiPro.stopNote(key: pitch, sfId: _soundfontId!);
            }
          });
        });
      }
    }

    // Calculate approximate end time of the last note to update status
    double lastEventTimeSec = 0;
    if (_notesData!.isNotEmpty) {
      var lastNote = _notesData!.last;
      lastEventTimeSec =
          (lastNote['offset'] + lastNote['duration']) * quarterNoteDurationSec;
    }

    Future.delayed(
        Duration(milliseconds: (lastEventTimeSec * 1000).round() + 100), () {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'پخش تمام شد.'; // Playback finished.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('پخش کننده نت موسیقی'), // Music Sheet Player
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // --- File Selection Button ---
              ElevatedButton.icon(
                icon: Icon(Icons.music_note),
                label: Text('انتخاب فایل نت موسیقی'), // Select Music Sheet File
                onPressed: _isLoading
                    ? null
                    : _pickAndUploadFile, // Disable during loading
              ),
              SizedBox(height: 10),

              // --- Display File Name and Status ---
              if (_isLoading) CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                _selectedFile != null
                    ? 'فایل انتخاب شده: ${p.basename(_selectedFile!.path)}' // Selected file:
                    : '',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _statusMessage.contains("خطا")
                        ? Colors.red
                        : Colors.black), // Error
                textDirection: TextDirection.rtl, // For Persian messages
              ),
              SizedBox(height: 20),

              // --- Tempo Slider ---
              Text('تمپو: ${_currentTempo.round()} BPM',
                  style: TextStyle(fontSize: 16)), // Tempo:
              Slider(
                value: _currentTempo,
                min: 30.0,
                max: 240.0,
                divisions: (240 - 30), // Number of divisions
                label: _currentTempo.round().toString(),
                onChanged: (_notesData == null ||
                        _isLoading) // Disable if no data or loading
                    ? null
                    : (newTempo) {
                        setState(() {
                          _currentTempo = newTempo;
                        });
                      },
              ),
              SizedBox(height: 20),

              // --- Play Button ---
              ElevatedButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text('پخش موسیقی'), // Play Music
                onPressed: (_notesData == null ||
                        _isLoading ||
                        _soundfontId == null)
                    ? null
                    : _playMusic, // Disable if no data, loading, or soundfont not loaded
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the midi pro instance when the widget is disposed
    _flutterMidiPro.dispose();
    super.dispose();
  }
}
