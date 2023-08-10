import 'dart:convert';

import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/weekly_weather.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeeklyWeatherController {
  final Function(WeeklyWeather weeklyWeather) _onWeeklyWeatherSuccess;
  final Function() _onWeeklyWeatherError;

  WeeklyWeatherController({
    required Function(WeeklyWeather weeklyWeather) onWeeklyWeatherSuccess,
    required Function() onWeeklyWeatherError,
  })  : _onWeeklyWeatherSuccess = onWeeklyWeatherSuccess,
        _onWeeklyWeatherError = onWeeklyWeatherError;

  Future<void> getWeeklyWeather(Place place) async {
    try {
      final queryParameters = {
        'latitude': place.coordinates.keys.toList()[0],
        'longitude': place.coordinates.values.toList()[0],
        'hourly': 'temperature_2m,weathercode',
      };

      var response = await http.get(
        Uri.https('api.open-meteo.com', '/v1/forecast', queryParameters),
      );

      var decodedResponse =
          (jsonDecode(utf8.decode(response.bodyBytes)) as Map)["hourly"];

      List<String> times = List<String>.from(decodedResponse["time"]).map((e) {
        DateTime dateTime = DateTime.parse(e);
        String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
        return formattedDate;
      }).toList();
      List<double> temperatures =
          List<double>.from(decodedResponse["temperature_2m"]);
      List<double> maxTemperatures = _getMaxTemperatures(times, temperatures);
      List<double> minTemperatures = _getMinTemperatures(times, temperatures);
      List<String> weatherDescriptions =
          List<int>.from(decodedResponse["weathercode"])
              .map((e) => WeeklyWeather.parseWeatherCodeToWeatherDescription(e))
              .toList();

      WeeklyWeather currentWeather = WeeklyWeather(
        dates: times.toSet().toList(),
        maxTemperatures: maxTemperatures,
        minTemperatures: minTemperatures,
        weatherDescriptions: weatherDescriptions,
      );

      _onWeeklyWeatherSuccess(currentWeather);
    } catch (e) {
      _onWeeklyWeatherError();
    }
  }

  List<double> _getMaxTemperatures(
      List<String> dates, List<double> temperatures) {
    Map<String, List<double>> groupedData = {};

    for (int i = 0; i < dates.length; i++) {
      if (!groupedData.containsKey(dates[i])) {
        groupedData[dates[i]] = [];
      }
      groupedData[dates[i]]!.add(temperatures[i]);
    }

    List<double> maxTemperatures = [];

    groupedData.forEach((time, values) {
      double maxTemperature = values
          .reduce((max, temperature) => temperature > max ? temperature : max);
      maxTemperatures.add(maxTemperature);
    });

    return maxTemperatures;
  }

  List<double> _getMinTemperatures(
      List<String> dates, List<double> temperatures) {
    Map<String, List<double>> groupedData = {};

    for (int i = 0; i < dates.length; i++) {
      if (!groupedData.containsKey(dates[i])) {
        groupedData[dates[i]] = [];
      }
      groupedData[dates[i]]!.add(temperatures[i]);
    }

    List<double> minTemperatures = [];

    groupedData.forEach((time, values) {
      double minTemperature = values
          .reduce((min, temperature) => temperature < min ? temperature : min);
      minTemperatures.add(minTemperature);
    });

    return minTemperatures;
  }
}
