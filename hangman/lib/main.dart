import 'package:flutter/material.dart';
import 'package:hangman/screens/welcome_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    ),
  );
}
