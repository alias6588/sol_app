import 'package:flutter/material.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/widgets/measure_card.dart';

// Custom widget to display a measure


class MusicScoreScreen extends StatelessWidget {
  const MusicScoreScreen({Key? key, required this.measures}) : super(key: key);

  // Simulate fetching required measures
  final List<Measure> measures;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Score Measures'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: measures
              .map((measure) => MeasureCard(measure: measure))
              .toList(),
        ),
      ),
    );
  }
}