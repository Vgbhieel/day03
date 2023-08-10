// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/current_weather_controller.dart';
import 'package:ex00/app/domain/models/current_weather.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/material.dart';

class CurrentWeatherPage extends StatefulWidget {
  final Place _place;
  bool _isLoading = true;

  CurrentWeatherPage({
    super.key,
    required Place place,
  }) : _place = place;

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late CurrentWeatherController _controller;
  late CurrentWeather _currentWeather;

  @override
  void initState() {
    super.initState();
    widget._isLoading = true;
    _controller =
        CurrentWeatherController(onCurrentWeatherSuccess: (currentWeather) {
      setState(() {
        _currentWeather = currentWeather;
        widget._isLoading = false;
      });
    }, onCurrentWeatherError: () {
      final snackBar = SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text('Ops, something went wrong. Please try again.',
            style: TextStyle(color: Theme.of(context).colorScheme.onError)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isLoading) {
      _controller.getCurrentWeather(widget._place);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: !widget._isLoading
              ? _getInfoWidgets(widget._place, context)
              : [
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
        ),
      ),
    );
  }

  List<Widget> _getInfoWidgets(Place place, BuildContext context) {
    List<Widget> list = [];
    list.add(Text(
      widget._place.name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));
    if (widget._place.region != null) {
      list.add(Text(
        widget._place.region!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ));
    }
    if (widget._place.country != null) {
      list.add(Text(
        widget._place.country!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ));
    }
    list.add(Text(
      '${_currentWeather.temperature} C°',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));

    list.add(Text(
      _currentWeather.weatherDescription,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));
    list.add(Text(
      '${_currentWeather.windSpeed} km/h',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));
    return list;
  }
}
