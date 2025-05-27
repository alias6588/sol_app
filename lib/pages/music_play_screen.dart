import 'package:flutter/material.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/widgets/bpm_control.dart';
import 'package:sol/widgets/measure_card.dart';
import 'package:provider/provider.dart';

// Custom widget to display a measure

class MusicPlayScreen extends StatefulWidget {
  const MusicPlayScreen({
    super.key,
  });

  // Simulate fetching required measures

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  int _currentBpm = 60; // Default BPM
  static const double _cardWidth = 200.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize the MusicPlayNotifier with the provided measures
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final musicPlayNotifier =
          Provider.of<MusicPlayNotifier>(context, listen: false);
      musicPlayNotifier.addListener(_scrollToCurrentMeasure);
    });
  }

  void _scrollToCurrentMeasure() {
    final notifier = Provider.of<MusicPlayNotifier>(context, listen: false);

    final double targetOffset = notifier.measureIndex * _cardWidth;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400), // سرعت انیمیشن
      curve: Curves.easeInOut, // نوع انیمیشن
    );
  }

  @override
  void dispose() {
    final musicPlayNotifier =
        Provider.of<MusicPlayNotifier>(context, listen: false);
    musicPlayNotifier.removeListener(_scrollToCurrentMeasure);
    _scrollController.dispose();
    musicPlayNotifier.stop();
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
                SizedBox(
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: musicPlayNotifier.measures.length,
                    itemBuilder: (BuildContext context, int index) =>
                        MeasureCard(
                      measureIndex: index,
                    ),
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
