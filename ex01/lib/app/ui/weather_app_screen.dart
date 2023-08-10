import 'package:ex00/app/ui/weather_app_page.dart';
import 'package:flutter/material.dart';

class WeatherAppScreen extends StatelessWidget {
  const WeatherAppScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WeatherAppPage(),
    );
  }
}
