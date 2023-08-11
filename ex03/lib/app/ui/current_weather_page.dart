// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/current_weather_controller.dart';
import 'package:ex00/app/domain/models/current_weather.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/utils/weather_icon_util.dart';

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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
    ThemeData theme = Theme.of(context);

    list.add(const SizedBox(height: 48));

    list.add(Text(
      widget._place.name,
      textAlign: TextAlign.center,
      style: theme.textTheme.displayLarge
          ?.copyWith(color: theme.colorScheme.primary),
    ));

    if (widget._place.region != null) {
      list.add(Text(widget._place.region!,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayMedium
              ?.copyWith(color: theme.colorScheme.secondary)));
    }

    if (widget._place.country != null) {
      list.add(Text(
        widget._place.country!,
        textAlign: TextAlign.center,
        style: theme.textTheme.displayMedium
            ?.copyWith(color: theme.colorScheme.secondary),
      ));
    }

    list.add(const SizedBox(height: 48));

    list.add(Text(
      '${_currentWeather.temperature}C°',
      textAlign: TextAlign.center,
      style: theme.textTheme.displayMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ));

    list.add(const SizedBox(height: 18));

    list.add(Text(
      _currentWeather.weatherDescription,
      textAlign: TextAlign.center,
      style: theme.textTheme.displaySmall
          ?.copyWith(color: theme.colorScheme.secondary),
    ));

    list.add(const SizedBox(height: 8));

    list.add(Icon(
      WeatherIconUtil.getIconFromWeatherDescription(
          _currentWeather.weatherDescription),
      size: 150,
      color: theme.colorScheme.primary,
    ));

    list.add(const SizedBox(height: 48));

    list.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.wind, color: theme.colorScheme.secondary),
        const Flexible(
          fit: FlexFit.loose,
          child: SizedBox(width: 8),
        ),
        Text(
          '${_currentWeather.windSpeed} km/h',
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall
              ?.copyWith(color: theme.colorScheme.secondary),
        ),
      ],
    ));

    return list;
  }
}
