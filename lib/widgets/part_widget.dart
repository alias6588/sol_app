import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/models/part.dart';
import 'package:sol/widgets/measure_card.dart';

class PartWidget extends StatefulWidget {
  final Part part;

  const PartWidget({super.key, required this.part});

  @override
  State<PartWidget> createState() => _PartWidgetState();
}

class _PartWidgetState extends State<PartWidget> {
  final ScrollController _scrollController = ScrollController();
  late final MusicPlayNotifier _musicPlayNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _musicPlayNotifier = Provider.of<MusicPlayNotifier>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the MusicPlayNotifier with the provided measures
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _musicPlayNotifier.addListener(_scrollToCurrentMeasure);
    });
  }

  void _scrollToCurrentMeasure() {
    if (!_scrollController.hasClients) return;

    final notifier = Provider.of<MusicPlayNotifier>(context, listen: false);

    const cardWidth = 220.0; // عرض کارت‌ها
    final double targetOffset = notifier.measureIndex * cardWidth;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (targetOffset > maxScroll) return;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400), // سرعت انیمیشن
      curve: Curves.easeInOut, // نوع انیمیشن
    );
  }

  @override
  void dispose() {
    _musicPlayNotifier.removeListener(_scrollToCurrentMeasure);
    _scrollController.dispose();
    _musicPlayNotifier.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.part.measures.length,
        itemBuilder: (BuildContext context, int index) => MeasureCard(
          measure: widget.part.measures[index],
        ),
      ),
    );
  }
}
