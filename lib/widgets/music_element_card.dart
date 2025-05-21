import 'package:flutter/material.dart';
import 'package:sol/models/music_elements/abstracts/musice_element.dart';

class MusicElementCard extends StatelessWidget {

  final MusicElement musicElement;

  const MusicElementCard({Key? key, required this.musicElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
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
