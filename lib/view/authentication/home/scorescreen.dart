import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreScreen extends StatelessWidget {
  final int score;

  const ScoreScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You scored',
              style: TextStyle(fontSize: 32),
            ),
            Text(
              '$score/${Get.arguments}',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate back to home screen
                Get.offAllNamed('/');
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
