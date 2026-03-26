import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

// TODO: 실제 API 키로 교체하세요
const _apiKey = 'YOUR_API_KEY';
const _baseUrl = 'https://api.openweathermap.org/data/2.5';

// ── 선택된 도시 ──────────────────────────────────────────
final selectedCityProvider = NotifierProvider<_CityNotifier, String>(_CityNotifier.new);

class _CityNotifier extends Notifier<String> {
  @override
  String build() => '서울';

  void select(String city) => state = city;
}

// ── 날씨 데이터 (AsyncNotifier) ──────────────────────────
class WeatherNotifier extends AsyncNotifier<WeatherData> {
  @override
  Future<WeatherData> build() async {
    final city = ref.watch(selectedCityProvider);
    return _fetchWeather(city);
  }

  Future<void> refresh() async {
    final city = ref.read(selectedCityProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWeather(city));
  }

  Future<WeatherData> _fetchWeather(String city) async {
    if (_apiKey == 'YOUR_API_KEY') {
      // API 키 없을 때 Mock 데이터
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockWeather(city);
    }

    final uri = Uri.parse(
      '$_baseUrl/weather?q=$city&lang=kr&appid=$_apiKey',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    }
    throw Exception('날씨 데이터를 불러오지 못했습니다 (${response.statusCode})');
  }

  WeatherData _mockWeather(String city) {
    final mockMap = {
      '서울': (temp: 14.0, desc: '맑음', icon: '01d'),
      '부산': (temp: 16.0, desc: '구름 조금', icon: '02d'),
      '제주': (temp: 18.0, desc: '흐림', icon: '04d'),
      '대구': (temp: 15.0, desc: '맑음', icon: '01d'),
    };
    final data = mockMap[city] ?? (temp: 13.0, desc: '맑음', icon: '01d');
    return WeatherData(
      cityName: city,
      tempC: data.temp,
      feelsLikeC: data.temp - 2,
      tempMinC: data.temp - 4,
      tempMaxC: data.temp + 3,
      description: data.desc,
      iconCode: data.icon,
      humidity: 55,
      windSpeed: 2.5,
      timestamp: DateTime.now(),
    );
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherData>(
  WeatherNotifier.new,
);

// ── 5일 예보 (mock) ──────────────────────────────────────
final forecastProvider = Provider<List<ForecastDay>>((ref) {
  final today = DateTime.now();
  return List.generate(5, (i) {
    final day = today.add(Duration(days: i + 1));
    final temps = [16.0, 18.0, 14.0, 12.0, 17.0];
    final icons = ['02d', '01d', '10d', '03d', '01d'];
    final descs = ['구름 조금', '맑음', '비', '흐림', '맑음'];
    return ForecastDay(
      date: day,
      tempMaxC: temps[i],
      tempMinC: temps[i] - 5,
      iconCode: icons[i],
      description: descs[i],
    );
  });
});

// ── 벚꽃 개화 예측 ────────────────────────────────────────
final blossomProvider = Provider<BlossomForecast>((ref) {
  final city = ref.watch(selectedCityProvider);
  return _predictBlossom(city);
});

/// 간이 벚꽃 개화 예측
/// 실제 기상청 데이터 기반 평균 개화일을 사용
BlossomForecast _predictBlossom(String city) {
  final now = DateTime.now();
  final year = now.year;

  // 도시별 평균 개화일 (월, 일)
  final avgBlossom = {
    '서울': (month: 4, day: 1),
    '부산': (month: 3, day: 25),
    '제주': (month: 3, day: 17),
    '대구': (month: 3, day: 28),
    '인천': (month: 4, day: 3),
    '광주': (month: 3, day: 28),
    '대전': (month: 3, day: 30),
  };

  final avg = avgBlossom[city] ?? (month: 4, day: 1);
  final predictedDate = DateTime(year, avg.month, avg.day);

  // 개화 기간: ±7일
  final startDate = predictedDate.subtract(const Duration(days: 3));
  final endDate = predictedDate.add(const Duration(days: 7));

  if (now.isAfter(startDate) && now.isBefore(endDate)) {
    return BlossomForecast(
      cityName: city,
      predictedDate: predictedDate,
      status: BlossomStatus.blooming,
      message: '🌸 지금 벚꽃이 피어 있어요!',
    );
  } else if (now.isBefore(startDate)) {
    final daysLeft = startDate.difference(now).inDays;
    return BlossomForecast(
      cityName: city,
      predictedDate: predictedDate,
      status: BlossomStatus.upcoming,
      message: '약 $daysLeft일 후 개화 예정',
    );
  } else {
    // 꽃이 진 경우, 내년 예측
    final nextYear = DateTime(year + 1, avg.month, avg.day);
    final daysLeft = nextYear.difference(now).inDays;
    return BlossomForecast(
      cityName: city,
      predictedDate: nextYear,
      status: BlossomStatus.passed,
      message: '올해 벚꽃은 졌어요. 내년까지 $daysLeft일',
    );
  }
}
