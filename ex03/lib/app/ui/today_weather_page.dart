// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/today_weather_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/today_weather.dart';
import 'package:flutter/material.dart';

class TodayWeatherPage extends StatefulWidget {
  final Place _place;
  bool _isLoading = true;

  TodayWeatherPage({
    super.key,
    required Place place,
  }) : _place = place;

  @override
  State<TodayWeatherPage> createState() => _TodayWeatherPageState();
}

class _TodayWeatherPageState extends State<TodayWeatherPage> {
  late TodayWeatherController _controller;
  late TodayWeather _todayWeather;

  @override
  void initState() {
    super.initState();
    widget._isLoading = true;
    _controller = TodayWeatherController(onTodayWeatherSuccess: (todayWeather) {
      setState(() {
        _todayWeather = todayWeather;
        widget._isLoading = false;
      });
    }, onTodayWeatherError: () {
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
      _controller.getTodayWeather(widget._place);
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
      '${_todayWeather.currentTemperature}C°',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));

    int index = 0;
    for (var hour in _todayWeather.hours) {
      list.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(hour),
              Text('${_todayWeather.temperatures[index]}C°'),
              Text(_todayWeather.weatherDescriptions[index]),
              Text('${_todayWeather.windspeeds[index]} km/h'),
            ],
          ),
        ],
      ));
      index = index + 1;
    }

    return list;
  }
}
