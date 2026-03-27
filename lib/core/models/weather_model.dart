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
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] as String,
      tempC: (json['main']['temp'] as num).toDouble(),
      feelsLikeC: (json['main']['feels_like'] as num).toDouble(),
      tempMinC: (json['main']['temp_min'] as num).toDouble(),
      tempMaxC: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      iconCode: json['weather'][0]['icon'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      timestamp: DateTime.now(),
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
