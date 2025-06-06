import 'package:flutter/material.dart';
import 'package:sol/models/music_elements/abstracts/musice_element.dart';
import 'package:sol/models/music_elements/abstracts/playable_music_element.dart';

class MusicElementCard extends StatelessWidget {
  final MusicElement musicElement;

  const MusicElementCard({super.key, required this.musicElement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: musicElement is PlayableMusicElement &&
                (musicElement as PlayableMusicElement).isPlaying
            ? Colors.green
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Text(
        musicElement.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
