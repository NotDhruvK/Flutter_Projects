import 'package:flutter/material.dart';
import 'package:hangman/data/words.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // C L A S S    V A R I A B L E S
  final String word = getWord();
  final _guessController = TextEditingController();
  var tries = 1;

  // C L A S S    M E T H O D S
  // TODO: Implement a _getHint function
  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(word),
              const SizedBox(
                height: 16,
                width: double.infinity,
              ),
              Image.asset('assets/$tries.jpeg'),
              const SizedBox(height: 16),
              const Text(
                'Your Guess',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: const InputDecoration(
                  fillColor: Colors.grey,
                ),
                textAlign: TextAlign.center,
                controller: _guessController,
                autofocus: true,
                onSubmitted: (value) {
                  setState(() {
                    tries++;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
