import 'dart:convert';

import 'package:ex00/app/domain/models/current_weather.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:http/http.dart' as http;

class CurrentWeatherController {
  final Function(CurrentWeather currentWeather) _onCurrentWeatherSuccess;
  final Function() _onCurrentWeatherError;

  CurrentWeatherController({
    required Function(CurrentWeather currentWeather) onCurrentWeatherSuccess,
    required Function() onCurrentWeatherError,
  })  : _onCurrentWeatherSuccess = onCurrentWeatherSuccess,
        _onCurrentWeatherError = onCurrentWeatherError;

  Future<void> getCurrentWeather(Place place) async {
    try {
      final queryParameters = {
        'latitude': place.coordinates.keys.toList()[0],
        'longitude': place.coordinates.values.toList()[0],
        'current_weather': 'true',
      };

      var response = await http.get(
        Uri.https('api.open-meteo.com', '/v1/forecast', queryParameters),
      );

      var decodedResponse = (jsonDecode(utf8.decode(response.bodyBytes))
          as Map)["current_weather"];

      CurrentWeather currentWeather = CurrentWeather(
        temperature: decodedResponse['temperature'],
        weatherDescription: CurrentWeather.parseWeatherCodeToWeatherDescription(
            decodedResponse['weathercode']),
        windSpeed: decodedResponse['windspeed'],
      );

      _onCurrentWeatherSuccess(currentWeather);
    } catch (e) {
      _onCurrentWeatherError();
    }
  }
}
