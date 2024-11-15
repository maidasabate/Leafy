import 'package:flutter/material.dart';

// Definir la función buildAppBar
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    title: const Text(
      'Leafy App',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}