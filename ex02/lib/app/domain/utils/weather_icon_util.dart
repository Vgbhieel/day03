import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherIconUtil {
  static IconData getIconFromWeatherDescription(String description) {
    switch (description) {
      case 'Clear sky':
        return CupertinoIcons.sun_max_fill;
      case 'Mainly clear':
      case 'Partly cloudy':
        return CupertinoIcons.cloud_sun_fill;
      case 'Overcast':
        return CupertinoIcons.cloud_fill;
      case 'Fog':
        return CupertinoIcons.cloud_fog_fill;
      case 'Depositing rime fog':
        return CupertinoIcons.cloud_fog;
      case 'Drizzle light intensity':
      case 'Drizzle moderate intensity':
      case 'Drizzle dense intensity':
        return CupertinoIcons.cloud_drizzle_fill;
      case 'Freezing drizzle light intensity':
      case 'Freezing drizzle dense intensity':
        return CupertinoIcons.cloud_sleet;
      case 'Rain slight intensity':
      case 'Rain moderate intensity':
      case 'Rain heavy intensity':
        return CupertinoIcons.cloud_rain_fill;
      case 'Freezing rain light intensity':
      case 'Freezing rain heavy intensity':
        return CupertinoIcons.cloud_snow_fill;
      case 'Snow fall slight intensity':
      case 'Snow fall moderate intensity':
      case 'Snow fall heavy intensity':
      case 'Snow grains':
        return CupertinoIcons.cloud_snow;
      case 'Rain showers slight':
      case 'Rain showers moderate':
      case 'Rain showers violent':
        return CupertinoIcons.cloud_bolt_fill;
      case 'Snow showers slight':
      case 'Snow showers heavy':
        return CupertinoIcons.cloud_snow_fill;
      case 'Thunderstorm slight or moderate':
      case 'Thunderstorm with slight hail':
      case 'Thunderstorm with heavy hail':
        return CupertinoIcons.cloud_bolt_rain_fill;
      default:
        return Icons.energy_savings_leaf;
    }
  }
}
