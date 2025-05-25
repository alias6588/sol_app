import 'package:flutter/material.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/widgets/bpm_control.dart';
import 'package:sol/widgets/measure_card.dart';
import 'package:provider/provider.dart';

// Custom widget to display a measure

class MusicPlayScreen extends StatefulWidget {
  const MusicPlayScreen({super.key, required this.measures});

  // Simulate fetching required measures
  final List<Measure> measures;

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  int _currentBpm = 60; // Default BPM

  @override
  void initState() {
    super.initState();
    // Initialize the MusicPlayNotifier with the provided measures
    Provider.of<MusicPlayNotifier>(context, listen: false)
        .initialize(widget.measures);
  }

  @override
  void dispose() {
    // Clean up the notifier when the screen is disposed
    Provider.of<MusicPlayNotifier>(context, listen: false).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('پخش نت موسیقی'),
        ),
        body: Consumer<MusicPlayNotifier>(
          builder: (BuildContext context, MusicPlayNotifier musicPlayNotifier,
              Widget? child) {
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: musicPlayNotifier.measures
                        .asMap()
                        .entries
                        .map((measure) => MeasureCard(
                              measureIndex: measure.key,
                            ))
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
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the buttons
                  children: [
                    ElevatedButton(
                      onPressed: musicPlayNotifier.isPlaying
                          ? null // Disable button if already playing
                          : () {
                              musicPlayNotifier.play(bpm: _currentBpm);
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.play_arrow),
                    ),
                    const SizedBox(width: 16), // Add some spacing
                    ElevatedButton(
                      onPressed: musicPlayNotifier.isPlaying
                          ? () {
                              musicPlayNotifier.stop();
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
            );
          },
        ));
  }
}
