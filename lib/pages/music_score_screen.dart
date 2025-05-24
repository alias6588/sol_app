import 'package:flutter/material.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_player.dart';
import 'package:sol/widgets/bpm_control.dart';
import 'package:sol/widgets/measure_card.dart';

// Custom widget to display a measure

class MusicScoreScreen extends StatefulWidget {
  const MusicScoreScreen({super.key, required this.measures});

  // Simulate fetching required measures
  final List<Measure> measures;

  @override
  State<MusicScoreScreen> createState() => _MusicScoreScreenState();
}

class _MusicScoreScreenState extends State<MusicScoreScreen> {
  int _currentBpm = 60; // Default BPM
  late final MusicPlayer _musicPlayer;

  @override
  void initState() {
    super.initState();
    _musicPlayer = MusicPlayer(measures: widget.measures);
    _musicPlayer.addListener(_onMusicPlayerStateChanged);
  }

  @override
  void dispose() {
    _musicPlayer.removeListener(_onMusicPlayerStateChanged);
    _musicPlayer.dispose(); // Important to clean up the notifier
    super.dispose();
  }

  void _onMusicPlayerStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پخش نت موسیقی'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: widget.measures
                  .map((measure) => MeasureCard(measure: measure))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: BpmControl(
                minBpm: 20,
                maxBpm: 120,
                onBpmChanged: (bpm) {
                  _currentBpm = bpm;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
            children: [
              ElevatedButton(
                onPressed: _musicPlayer.isPlaying
                    ? null // Disable button if already playing
                    : () {
                        _musicPlayer.play(bpm: _currentBpm);
                      },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.play_arrow),
              ),
              const SizedBox(width: 16), // Add some spacing
              ElevatedButton(
                onPressed: _musicPlayer.isPlaying
                    ? () {
                        _musicPlayer.stop();
                      }
                    : null, // Disable if not playing
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.stop),
              ),
            ],
          )
        ],
      ),
    );
  }
}
