import 'package:dummy/SpaceX_API/spacex_launches_screen.dart';
import 'package:dummy/dashboard/dashboard.dart';
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
      title: 'Flutter Dummy UI Challenges',
      home: DashboardOnePage(),
    );
  }
}
