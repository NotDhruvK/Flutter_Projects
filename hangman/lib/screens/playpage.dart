import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/data/words.dart';
import 'package:hangman/screens/final_page.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // C L A S S    V A R I A B L E S
  final String word = getWord();
  String displayWord = '_______';
  final _guessController = TextEditingController();
  int tries = 1;

  // C L A S S    M E T H O D S
  void _updateDisplayWord() {
    final guess = _guessController.text.toLowerCase();
    final target = word.toLowerCase();

    List<String> updated = displayWord.split('');

    for (int i = 0; i < guess.length; i++) {
      String guessedChar = guess[i];

      for (int j = 0; j < target.length; j++) {
        if (guessedChar == target[j]) {
          updated[j] = target[j]; // reveal at correct position
        }
      }
    }
    displayWord = updated.join('').toUpperCase();
  }

  void _getHint() {
    List<String> current = displayWord.split('');
    List<int> hiddenIndexes = [];

    for (int i = 0; i < current.length; i++) {
      if (current[i] == '_') {
        hiddenIndexes.add(i);
      }
    }
    final randomIndex = hiddenIndexes[Random().nextInt(hiddenIndexes.length)];
    current[randomIndex] = word[randomIndex].toUpperCase();
    setState(() {
      displayWord = current.join('');
    });
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (word.toLowerCase() == displayWord.toLowerCase()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const FinalPage(winState: true),
        ),
      );
    }
    if (tries == 8) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const FinalPage(winState: false),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(word),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          displayWord,
                          style: const TextStyle(
                            letterSpacing: 10,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.amber,
                      onPressed: _getHint,
                      icon: const Icon(Icons.lightbulb),
                    ),
                  ],
                ),
              ),

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
                controller: _guessController,
                autofocus: true,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Enter 7-letter word',
                ),
                onSubmitted: (value) {
                  if (value.length != 7) return; // safety check

                  setState(() {
                    tries++;
                    _updateDisplayWord();
                    _guessController.clear();
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
