// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/today_weather_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/today_weather.dart';
import 'package:ex00/app/domain/utils/weather_icon_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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

    list.add(AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
                isCurved: true,
                spots: List.generate(
                  _todayWeather.temperatures.length,
                  (index) {
                    return FlSpot(
                        index.toDouble(), _todayWeather.temperatures[index]);
                  },
                ),
                dotData: const FlDotData(show: true),
                color: theme.colorScheme.primary),
          ],
          maxY: _todayWeather.temperatures
                  .reduce((max, temperature) =>
                      temperature > max ? temperature : max)
                  .toInt()
                  .toDouble() +
              1,
          minY: _todayWeather.temperatures
                  .reduce((min, temperature) =>
                      temperature < min ? temperature : min)
                  .toInt()
                  .toDouble() -
              1,
          clipData: const FlClipData.all(),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
          backgroundColor: theme.colorScheme.primaryContainer,
          lineTouchData: const LineTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
                axisNameSize: 35,
                axisNameWidget: Text(
                  "Today temperatures",
                  style: theme.textTheme.displaySmall
                      ?.copyWith(color: theme.colorScheme.secondary),
                ),
                sideTitles: const SideTitles(
                  showTitles: false,
                )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (index, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(_todayWeather.hours[index.toInt()]),
                );
              },
            )),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('${value.toInt()}°C'),
                );
              },
            )),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    ));

    list.add(SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _getWeatherWidgets(context),
      ),
    ));

    return list;
  }

  List<Widget> _getWeatherWidgets(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var list = <Widget>[const SizedBox(height: 100)];
    int index = 0;
    for (var hour in _todayWeather.hours) {
      list.add(Material(
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                hour,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Icon(
                WeatherIconUtil.getIconFromWeatherDescription(
                  _todayWeather.weatherDescriptions[index],
                ),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                '${_todayWeather.temperatures[index]}C°',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.wind, color: theme.colorScheme.secondary),
                  const Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(width: 8),
                  ),
                  Text(
                    '${_todayWeather.windspeeds[index]} km/h',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
      if (index != _todayWeather.weatherDescriptions.length - 1) {
        list.add(const SizedBox(width: 8));
      }
      index = index + 1;
    }
    return list;
  }
}
