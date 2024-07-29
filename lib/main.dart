import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // weather api_key = 6e1a2ede6e5df1929f7400be08805b2d
  // google  api_key = AIzaSyDdGXy8CRx8y2S1Q8IJw13pOGyRjVMHyl8
  final _weatherService = WeatherService("6e1a2ede6e5df1929f7400be08805b2d",
      "AIzaSyDdGXy8CRx8y2S1Q8IJw13pOGyRjVMHyl8");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(
        weatherService: _weatherService,
      ),
    );
  }
}
