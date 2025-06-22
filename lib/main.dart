import 'package:dummy/apple_liquid_glass.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dummy app for linkedin posting',
      home: Scaffold(
        // appBar: AppBar(backgroundColor: Colors.grey[300]),
        body: const LiquidGlassHome(),
      ),
    );
  }
}
