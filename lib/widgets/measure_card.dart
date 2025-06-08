import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/widgets/music_element_card.dart';

class MeasureCard extends StatefulWidget {
  final Measure measure;

  const MeasureCard({super.key, required this.measure});

  @override
  State<MeasureCard> createState() => _MeasureCardState();
}

class _MeasureCardState extends State<MeasureCard> {
  late final MusicPlayNotifier _musicPlayNotifier;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _musicPlayNotifier = Provider.of<MusicPlayNotifier>(context, listen: false);
  }

  @override
  initState() {
    super.initState();
    // Initialize any state or variables if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _musicPlayNotifier.addListener(_scrollToPosition);
    });
  }

  @override
  void dispose() {
    _musicPlayNotifier.removeListener(_scrollToPosition);
    _scrollController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToPosition() {
    if (!_scrollController.hasClients) return;

    final notifier = Provider.of<MusicPlayNotifier>(context, listen: false);

    if (notifier.measureIndex + 1 != widget.measure.measureNumber) {
      return; // Only scroll if the current measure is the one being played
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    var targetOffset = notifier.playingElementIndex * 20.0;

    if (targetOffset == maxScroll) return;

    if (targetOffset > maxScroll) {
      targetOffset = maxScroll; // Prevent scrolling beyond max
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400), // سرعت انیمیشن
      curve: Curves.easeInOut, // نوع انیمیشن
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.measure.isPlaying
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
              'Measure ${widget.measure.measureNumber}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: widget.measure.playableElements.length,
                itemBuilder: (context, index) => MusicElementCard(
                    musicElement: widget.measure.playableElements[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
