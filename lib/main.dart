import 'package:flutter/material.dart';
import 'package:tp_gregory/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = "Accueil Morpion";
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        color: Colors.white,
        home: HomeScreen(
          title: title,
        ),
      );
}
