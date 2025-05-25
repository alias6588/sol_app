import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/widgets/music_element_card.dart';

class MeasureCard extends StatelessWidget {
  final int measureIndex;

  const MeasureCard({super.key, required this.measureIndex});

  @override
  Widget build(BuildContext context) {
    return Selector<MusicPlayNotifier, Measure>(
      selector: (context, musicPlay) => musicPlay.measures[measureIndex],
      builder: (BuildContext context, measure, Widget? child) {
        return Card(
          color: measure.isPlaying
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Measure ${measure.measureNumber}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: measure.cleanElements.map((element) {
                      // Assuming each element has a 'noteName' property
                      return MusicElementCard(musicElement: element);
                      // ignore: dead_code
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
