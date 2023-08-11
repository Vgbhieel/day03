// ignore_for_file: must_be_immutable

import 'package:ex00/app/domain/controllers/weekly_weather_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/weekly_weather.dart';
import 'package:ex00/app/domain/utils/weather_icon_util.dart';
import 'package:fl_chart/fl_chart.dart';
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
                  _weeklyWeather.maxTemperatures.length,
                  (index) {
                    return FlSpot(index.toDouble(),
                        _weeklyWeather.maxTemperatures[index]);
                  },
                ),
                dotData: const FlDotData(show: true),
                color: theme.colorScheme.primary),
            LineChartBarData(
                isCurved: true,
                spots: List.generate(
                  _weeklyWeather.minTemperatures.length,
                  (index) {
                    return FlSpot(index.toDouble(),
                        _weeklyWeather.minTemperatures[index]);
                  },
                ),
                dotData: const FlDotData(show: true),
                color: theme.colorScheme.secondary),
          ],
          maxX: 6,
          minX: 0,
          maxY: _weeklyWeather.maxTemperatures
                  .reduce((max, temperature) =>
                      temperature > max ? temperature : max)
                  .toInt()
                  .toDouble() +
              3,
          minY: _weeklyWeather.minTemperatures
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
                  "Weekly temperatures",
                  style: theme.textTheme.displaySmall
                      ?.copyWith(color: theme.colorScheme.secondary),
                ),
                sideTitles: const SideTitles(
                  showTitles: false,
                )),
            bottomTitles: AxisTitles(
                axisNameSize: 50,
                axisNameWidget: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text("Max temperature"),
                      const SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text("Min temperature"),
                    ],
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (index, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                          _formatDate(_weeklyWeather.dates[index.toInt()])),
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
    for (var date in _weeklyWeather.dates) {
      list.add(Material(
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                _formatDate(date),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Icon(
                WeatherIconUtil.getIconFromWeatherDescription(
                  _weeklyWeather.weatherDescriptions[index],
                ),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                '${_weeklyWeather.maxTemperatures[index]}C° max',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${_weeklyWeather.minTemperatures[index]}C° min',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ));
      if (index != _weeklyWeather.dates.length - 1) {
        list.add(const SizedBox(width: 8));
      }
      index = index + 1;
    }
    return list;
  }

  String _formatDate(String date) {
    return date.substring(0, 5).replaceAll('-', '/');
  }
}
