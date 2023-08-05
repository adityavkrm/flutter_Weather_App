import 'package:flutter/material.dart';
import 'package:weather_app/HomeScreen.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark(useMaterial3: true),
      home: HomeScreen(),
      
    );
  }
}
