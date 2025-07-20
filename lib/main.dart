/*

CODED BY AZIZ UR RAHMAN
https://www.github.com/azix-khan 
 
*/

import 'package:dummy/coffee_machine_animation/CoffeeApp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Dummy UI Challenges',
      // home: TicketBooking(),
    );
  }
}
