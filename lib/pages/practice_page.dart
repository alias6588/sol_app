import 'package:flutter/material.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Practice Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}