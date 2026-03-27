class HourlyForecast {
  final String label; // '지금' or 'N시'
  final double tempC;
  final int conditionCode;

  const HourlyForecast({
    required this.label,
    required this.tempC,
    required this.conditionCode,
  });

  String get emoji => _conditionEmoji(conditionCode);

  static String _conditionEmoji(int code) {
    if (code == 1000) return '☀️';
    if (code == 1003) return '🌤';
    if (code == 1006 || code == 1009) return '☁️';
    if (code == 1030 || code == 1135 || code == 1147) return '🌫';
    if (code >= 1273 && code <= 1282) return '⛈';
    if (code >= 1210 && code <= 1264) return '🌨';
    if (code >= 1150 && code <= 1201) return '🌧';
    if (code >= 1063 && code <= 1072) return '🌦';
    return '⛅';
  }
}

class WeatherData {
  final String cityName;
  final double tempC;
  final double feelsLikeC;
  final double tempMinC;
  final double tempMaxC;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final DateTime timestamp;
  final List<HourlyForecast> hourly;

  const WeatherData({
    required this.cityName,
    required this.tempC,
    required this.feelsLikeC,
    required this.tempMinC,
    required this.tempMaxC,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
    this.hourly = const [],
  });

  factory WeatherData.fromWeatherApi(Map<String, dynamic> json, String cityKo) {
    final current = json['current'] as Map<String, dynamic>;
    final condition = current['condition'] as Map<String, dynamic>;
    final forecastDay = json['forecast']?['forecastday']?[0];
    final dayData = forecastDay?['day'];

    // 시간별 예보: 현재 시각 기준 이후 5개
    final hourlyList = <HourlyForecast>[];
    final hours = forecastDay?['hour'] as List<dynamic>?;
    if (hours != null) {
      final nowHour = DateTime.now().hour;
      bool foundFirst = false;
      for (final h in hours) {
        final timeStr = h['time'] as String; // "2026-03-27 14:00"
        final hh = int.parse(timeStr.split(' ')[1].split(':')[0]);
        if (hh >= nowHour && hourlyList.length < 5) {
          hourlyList.add(
            HourlyForecast(
              label: foundFirst ? '$hh시' : '지금',
              tempC: (h['temp_c'] as num).toDouble(),
              conditionCode: h['condition']['code'] as int,
            ),
          );
          foundFirst = true;
        }
      }
    }

    return WeatherData(
      cityName: cityKo,
      tempC: (current['temp_c'] as num).toDouble(),
      feelsLikeC: (current['feelslike_c'] as num).toDouble(),
      tempMinC: dayData != null
          ? (dayData['mintemp_c'] as num).toDouble()
          : (current['temp_c'] as num).toDouble() - 4,
      tempMaxC: dayData != null
          ? (dayData['maxtemp_c'] as num).toDouble()
          : (current['temp_c'] as num).toDouble() + 3,
      description: condition['text'] as String,
      iconCode: condition['icon'] as String,
      humidity: (current['humidity'] as num).toInt(),
      windSpeed: ((current['wind_kph'] as num) / 3.6),
      timestamp: DateTime.now(),
      hourly: hourlyList,
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double tempMaxC;
  final double tempMinC;
  final String iconCode;
  final String description;

  const ForecastDay({
    required this.date,
    required this.tempMaxC,
    required this.tempMinC,
    required this.iconCode,
    required this.description,
  });
}

/// 벚꽃 개화 예측 모델
class BlossomForecast {
  final String cityName;
  final DateTime? predictedDate; // null이면 이미 지났거나 아직 계절 아님
  final BlossomStatus status;
  final String message;

  const BlossomForecast({
    required this.cityName,
    required this.predictedDate,
    required this.status,
    required this.message,
  });
}

enum BlossomStatus {
  blooming, // 현재 개화 중
  upcoming, // 곧 개화 예정
  passed, // 이미 지남
  tooEarly, // 아직 시즌 아님
}
