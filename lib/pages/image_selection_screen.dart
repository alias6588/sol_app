import 'dart:io'; // For File
import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:path/path.dart' as p; // For getting basename
import 'package:provider/provider.dart';
import 'package:sol/exceptions/post_file_exception.dart';
import 'package:sol/exceptions/select_file_exception.dart';
import 'package:sol/models/measure.dart' as measure_model show Measure;
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/pages/music_play_screen.dart';

class ImageSelectionScreen extends StatefulWidget {
  const ImageSelectionScreen({super.key});

  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  File? _selectedFile;
  bool _isLoading = false;
  String _statusMessage =
      'لطفاً یک فایل نت موسیقی انتخاب کنید.'; // Please select a music sheet file.

  // If you are using a real device or iOS simulator, enter your computer's local IP (e.g., 192.168.1.100).
  final String? _backendUrl = dotenv.env['BACKEND_URL'];

  @override
  void initState() {
    super.initState();
    if (_backendUrl == null || _backendUrl!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _statusMessage =
              'آدرس سرور تنظیم نشده است.'; // Backend URL is not set.
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'آدرس سرور تنظیم نشده است. لطفاً فایل .env را بررسی کنید.', // Backend URL is not set. Please check the .env file.
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }
  }

  // --- Pick and Upload File ---
  Future<File> _pickUpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Only image files
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    } else {
      throw SelectFileException('انتخاب فایل لغو شد.');
    }
  }

  Future<List<measure_model.Measure>> uploadFile() async {
    String errorMessage =
        'خطا در پردازش فایل در سرور.'; // Error processing file on server.
    try {
      // Build multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_backendUrl!));
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

      if (response.statusCode == 200) {
        // Processing was successful
        List<dynamic> decodedData = jsonDecode(response.body);
        // Convert List<dynamic> to List<NoteEvent>
        List<measure_model.Measure> measures = decodedData
            .map((data) => measure_model.Measure.fromJson(data))
            .toList();
        return measures;

        // Navigate to the MusicPlayerScreen with the note data
      } else {
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
      }
    } catch (e) {
      // Network or other errors
      errorMessage += "\n$e";
    }
    throw PostFileException(errorMessage); // Throw custom exception}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('انتخاب فایل نت موسیقی'), // Select Music Sheet File
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
                    : () async {
                        try {
                          var file = await _pickUpFile();
                          setState(() {
                            _isLoading = true;
                            _selectedFile = file;
                            _statusMessage =
                                'فایل انتخاب شد: ${p.basename(file.path)}'; // File selected: filename
                          });

                          var measures = await uploadFile();
                          setState(() {
                            _isLoading = false;
                            _statusMessage =
                                'پردازش کامل شد. آماده پخش.'; // Processing complete. Ready to play.
                          });
                          Provider.of<MusicPlayNotifier>(context, listen: false)
                              .initialize(measures);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MusicPlayScreen(measures: measures),
                            ),
                          );
                        } on SelectFileException catch (e) {
                          setState(() {
                            _statusMessage =
                                e.message; // File selection cancelled.
                          });
                        } on PostFileException catch (e) {
                          setState(() {
                            _statusMessage =
                                e.message; // Error processing file.
                          });
                        } on Exception catch (e) {
                          setState(() {
                            _statusMessage = '$e'; // File selection cancelled.
                          });
                        } finally {
                          setState(() {
                            _isLoading = false; // Reset loading state
                          });
                        }
                      }, // Disable during loading
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
            ],
          ),
        ),
      ),
    );
  }
}
