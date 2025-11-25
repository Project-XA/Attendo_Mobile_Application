import 'package:flutter/material.dart';
import 'package:mobile_app/feature/start_screen/start_page.dart';

class AttendencyApp extends StatelessWidget {
  const AttendencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: StartPage(),
    );
  }
}
