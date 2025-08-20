import 'package:flutter/material.dart';
import 'shopping_app.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Flutter Riverpod System
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Riverpod System",
      debugShowCheckedModeBanner: false,
      home: ShoppingApp(),
    );
  }
}
