import 'package:flutter/material.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/widgets/bpm_control.dart';
import 'package:sol/widgets/measure_card.dart';

// Custom widget to display a measure

class MusicScoreScreen extends StatefulWidget {
  const MusicScoreScreen({Key? key, required this.measures}) : super(key: key);

  // Simulate fetching required measures
  final List<Measure> measures;

  @override
  State<MusicScoreScreen> createState() => _MusicScoreScreenState();
}

class _MusicScoreScreenState extends State<MusicScoreScreen> {
  int _currentBpm = 60; // Default BPM
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Score Measures'),
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
                  print('BPM changed to: $_currentBpm');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
