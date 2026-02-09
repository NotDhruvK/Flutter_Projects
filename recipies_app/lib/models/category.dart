import 'package:flutter/material.dart';

class Category {
  // C O N S T R U C T O R
  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,
  });

  // C L A S S    V A R I A B L E S
  final String id;
  final String title;
  final Color color;

  // C L A S S    M E T H O D S
}
