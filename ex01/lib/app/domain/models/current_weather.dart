class CurrentWeather {
  final double temperature;
  final String weatherDescription;
  final double windSpeed;

  const CurrentWeather({
    required this.temperature,
    required this.weatherDescription,
    required this.windSpeed,
  });

  static String parseWeatherCodeToWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
        return 'Fog';
      case 48:
        return 'Depositing rime fog';
      case 51:
        return 'Drizzle light intensity';
      case 53:
        return 'Drizzle moderate intensity';
      case 55:
        return 'Drizzle dense intensity';
      case 56:
        return 'Freezing drizzle light intensity';
      case 57:
        return 'Freezing drizzle dense intensity';
      case 61:
        return 'Rain slight intensity';
      case 63:
        return 'Rain moderate intensity';
      case 65:
        return 'Rain heavy intensity';
      case 66:
        return 'Freezing rain ligh intensity';
      case 67:
        return 'Freezing rain heavy intensity';
      case 71:
        return 'Snow fall slight intensity';
      case 73:
        return 'Snow fall moderate intensity';
      case 75:
        return 'Snow fall heavy intensity';
      case 77:
        return 'Snow grains';
      case 80:
        return 'Rain showers slight';
      case 81:
        return 'Rain showers moderate';
      case 82:
        return 'Rain showers violent';
      case 85:
        return 'Snow showers slight';
      case 86:
        return 'Snow showers heavy';
      case 95:
        return 'Thunderstorm slight or moderate';
      case 96:
        return 'Thunderstorm with slight hail';
      case 99:
        return 'Thunderstorm with heavy hail';
      default:
        return 'Unknown weather description';
    }
  }
}
