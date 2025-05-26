import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'pages/image_selection_screen.dart'; // Import the image selection screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  runApp(ChangeNotifierProvider(
      create: (context) => MusicPlayNotifier(measures: []),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sol !', // Music Sheet Player
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Start with the ImageSelectionScreen
      home: ImageSelectionScreen(),
    );
  }
}
