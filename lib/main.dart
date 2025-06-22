import 'package:dummy/ui_3d_flutter/ui_o3d.dart';
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
      title: 'Flutter 3D beautiful ui using O3D dependency',
      home: Scaffold(body: const UIO3D()),
    );
  }
}
