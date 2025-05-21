import 'package:flutter/material.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/widgets/music_element_card.dart';

class MeasureCard extends StatelessWidget {
  final Measure measure;

  const MeasureCard({Key? key, required this.measure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  ;
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
