/*

CODED BY AZIZ UR RAHMAN
https://www.github.com/azix-khan 
 
*/

import 'package:dummy/ticket_booking/ticket_booking.dart';
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
      home: TicketBooking(),
    );
  }
}
