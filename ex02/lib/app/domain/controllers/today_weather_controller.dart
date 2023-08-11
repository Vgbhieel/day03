import 'dart:convert';

import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/domain/models/today_weather.dart';
import 'package:ex00/app/domain/models/weekly_weather.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TodayWeatherController {
  final Function(TodayWeather todayWeather) _onTodayWeatherSuccess;
  final Function() _onTodayWeatherError;

  TodayWeatherController({
    required Function(TodayWeather todayWeather) onTodayWeatherSuccess,
    required Function() onTodayWeatherError,
  })  : _onTodayWeatherSuccess = onTodayWeatherSuccess,
        _onTodayWeatherError = onTodayWeatherError;

  Future<void> getTodayWeather(Place place) async {
    try {
      final queryParameters = {
        'latitude': place.coordinates.keys.toList()[0],
        'longitude': place.coordinates.values.toList()[0],
        'hourly': 'temperature_2m,weathercode,windspeed_10m',
        'forecast_days': '1',
        'current_weather': 'true',
      };

      var response = await http.get(
        Uri.https('api.open-meteo.com', '/v1/forecast', queryParameters),
      );

      var currentTemperature = (jsonDecode(utf8.decode(response.bodyBytes))
          as Map)["current_weather"]["temperature"];

      var decodedResponse =
          (jsonDecode(utf8.decode(response.bodyBytes)) as Map)["hourly"];

      List<String> hours = List<String>.from(decodedResponse["time"]).map((e) {
        DateTime dateTime = DateTime.parse(e);
        String formattedDate = DateFormat('HH:mm').format(dateTime);
        return formattedDate;
      }).toList();
      List<double> temperatures =
          List<double>.from(decodedResponse["temperature_2m"]);
      List<double> windspeeds =
          List<double>.from(decodedResponse["windspeed_10m"]);
      List<String> weatherDescriptions =
          List<int>.from(decodedResponse["weathercode"])
              .map((e) => WeeklyWeather.parseWeatherCodeToWeatherDescription(e))
              .toList();

      TodayWeather currentWeather = TodayWeather(
        currentTemperature: currentTemperature,
        hours: hours,
        temperatures: temperatures,
        windspeeds: windspeeds,
        weatherDescriptions: weatherDescriptions,
      );

      _onTodayWeatherSuccess(currentWeather);
    } catch (e) {
      _onTodayWeatherError();
    }
  }
}
