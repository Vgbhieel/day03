// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/weekly_weather_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/weekly_weather.dart';
import 'package:flutter/material.dart';

class WeeklyWeatherPage extends StatefulWidget {
  final Place _place;
  bool _isLoading = true;

  WeeklyWeatherPage({
    super.key,
    required Place place,
  }) : _place = place;

  @override
  State<WeeklyWeatherPage> createState() => _WeeklyWeatherPageState();
}

class _WeeklyWeatherPageState extends State<WeeklyWeatherPage> {
  late WeeklyWeatherController _controller;
  late WeeklyWeather _weeklyWeather;

  @override
  void initState() {
    super.initState();
    widget._isLoading = true;
    _controller =
        WeeklyWeatherController(onWeeklyWeatherSuccess: (weeklyWeather) {
      setState(() {
        _weeklyWeather = weeklyWeather;
        widget._isLoading = false;
      });
    }, onWeeklyWeatherError: () {
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
      _controller.getWeeklyWeather(widget._place);
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

    for (int i = 1; i <= 7; i++) {
      var index = i - 1;
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_weeklyWeather.dates[index]),
          Text('${_weeklyWeather.minTemperatures[index]}C°'),
          Text('${_weeklyWeather.maxTemperatures[index]}C°'),
          Text(_weeklyWeather.weatherDescriptions[index]),
        ],
      ));
    }

    return list;
  }
}
