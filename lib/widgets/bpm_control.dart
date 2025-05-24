import 'package:flutter/material.dart';

class BpmControl extends StatefulWidget {
  final int minBpm;
  final int maxBpm;
  final ValueChanged<int>? onBpmChanged; // <---
  const BpmControl({
    Key? key,
    this.minBpm = 30,
    this.maxBpm = 300,
    this.onBpmChanged,
  }) : super(key: key);

  @override
  State<BpmControl> createState() => _BpmControlState();
}

class _BpmControlState extends State<BpmControl> {
  late int _bpm;

  @override
  void initState() {
    super.initState();
    _bpm = widget.maxBpm.clamp(widget.minBpm, widget.maxBpm);
  }

  void _incrementBpm() {
    setState(() {
      if (_bpm < widget.maxBpm) {
        _bpm++;
        widget.onBpmChanged?.call(_bpm); // <---
      }
    });
  }

  void _decrementBpm() {
    setState(() {
      if (_bpm > widget.minBpm) {
        _bpm--;
        widget.onBpmChanged?.call(_bpm); // <---
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _bpm > widget.minBpm ? _decrementBpm : null,
        ),
        SizedBox(
          width: 70,
          child: TextField(
            controller: TextEditingController(text: '$_bpm')
              ..selection = TextSelection.collapsed(offset: '$_bpm'.length),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onSubmitted: (value) {
              final int? newBpm = int.tryParse(value);
              if (newBpm != null &&
                  newBpm >= widget.minBpm &&
                  newBpm <= widget.maxBpm) {
                setState(() {
                  _bpm = newBpm;
                  widget.onBpmChanged?.call(_bpm); // <---
                });
              }
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('bpm'),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _bpm < widget.maxBpm ? _incrementBpm : null,
        ),
      ],
    );
  }
}
