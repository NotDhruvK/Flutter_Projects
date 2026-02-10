import 'package:flutter/material.dart';
import 'package:hangman/screens/welcome_screen.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key, required this.winState});

  final bool winState;

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  // C L A S S      M E T H O D S
  void _onButtonPress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget win = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Win!!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 48,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                elevation: 3,
              ),
              onPressed: _onButtonPress,
              child: const Text('Play Again'),
            ),
          ),
        ],
      ),
    );

    final Widget lose = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Lose :(',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          Image.asset('assets/8.jpeg'),
          const SizedBox(height: 16),
          const SizedBox(
            height: 48,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                elevation: 3,
              ),
              onPressed: _onButtonPress,
              child: const Text('Try Again'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: widget.winState ? win : lose,
    );
  }
}
