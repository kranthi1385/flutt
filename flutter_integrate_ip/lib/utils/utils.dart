import 'package:flutter/material.dart';

Shader shadermaskFunc(Rect bounds) {
  return const RadialGradient(
    center: Alignment.topLeft,
    radius: 1.0,
    colors: <Color>[
      Color(0xFF8971d3),
      Color(0xFF5fb9bd),
      Color(0xFF51d1b6),
      Color(0xFF47e2b1),
    ],
    tileMode: TileMode.mirror,
  ).createShader(bounds);
}

ThemeData darkTheme =  ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        primary: const Color.fromARGB(255, 0, 128, 128),
        secondary: Colors.purple,
        brightness: Brightness.dark
      ),
    );
ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        primary: Colors.teal.shade300,
        secondary: Colors.purple,
        brightness: Brightness.light
      ),
);