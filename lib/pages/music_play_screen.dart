import 'package:flutter/material.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/pages/practice_page.dart';
import 'package:sol/widgets/bpm_control.dart';
import 'package:provider/provider.dart';
import 'package:sol/widgets/part_widget.dart';

// Custom widget to display a measure

class MusicPlayScreen extends StatelessWidget {
  // Simulate fetching required measures

 

  const MusicPlayScreen({super.key});
  // Default BPM
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
                ...musicPlayNotifier.parts.map(
                  (part) => PartWidget(part: part),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: BpmControl(
                      minBpm: 20,
                      maxBpm: 240,
                      initialBpm: musicPlayNotifier.currentBpm,
                      onBpmChanged: (bpm) {
                        //todo: Update the BPM in the notifier
                        musicPlayNotifier.updateBpm(bpm);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the buttons
                    children: [
                      ElevatedButton(
                        onPressed: musicPlayNotifier.isPlaying
                            ? null // Disable button if already playing
                            : () {
                                musicPlayNotifier.play();
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
                      const Spacer(flex: 1),
                      ElevatedButton.icon(
                        onPressed: () {
                          musicPlayNotifier.stop();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PracticePage(),
                              ));
                        },
                        icon: const Icon(Icons.school),
                        label: const Text('رفتن به صفحه تمرین'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
