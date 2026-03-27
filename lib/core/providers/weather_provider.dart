import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/weather_model.dart';

const _baseUrl = 'https://api.openweathermap.org/data/2.5';

// 한국어 도시명 → OpenWeather 영문 쿼리
const _cityQuery = {
  '서울': 'Seoul,KR',
  '부산': 'Busan,KR',
  '제주': 'Jeju,KR',
  '대구': 'Daegu,KR',
  '인천': 'Incheon,KR',
  '광주': 'Gwangju,KR',
  '대전': 'Daejeon,KR',
};

Uri _weatherUri(String cityKo) {
  final q = _cityQuery[cityKo] ?? '$cityKo,KR';
  if (kIsWeb) {
    final base = Uri.base;
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: '/api/weather',
      queryParameters: {'city': q},
    );
  }
  return Uri.parse('$_baseUrl/weather').replace(
    queryParameters: {
      'q': q,
      'appid': ApiKeys.openWeather,
      'units': 'metric',
      'lang': 'kr',
    },
  );
}

Uri _forecastUri(String cityKo) {
  final q = _cityQuery[cityKo] ?? '$cityKo,KR';
  if (kIsWeb) {
    final base = Uri.base;
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: '/api/weather',
      queryParameters: {'city': q, 'type': 'forecast'},
    );
  }
  return Uri.parse('$_baseUrl/forecast').replace(
    queryParameters: {
      'q': q,
      'appid': ApiKeys.openWeather,
      'units': 'metric',
      'lang': 'kr',
      'cnt': '40',
    },
  );
}

// ── 선택된 도시 ──────────────────────────────────────────
final selectedCityProvider = NotifierProvider<_CityNotifier, String>(
  _CityNotifier.new,
);

class _CityNotifier extends Notifier<String> {
  @override
  String build() => '서울';

  void select(String city) => state = city;
}

// ── 날씨 데이터 ──────────────────────────────────────────
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
    final uri = _weatherUri(city);
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final data = WeatherData.fromJson(json.decode(res.body));
      return WeatherData(
        cityName: city, // 한국어 도시명으로 표시
        tempC: data.tempC,
        feelsLikeC: data.feelsLikeC,
        tempMinC: data.tempMinC,
        tempMaxC: data.tempMaxC,
        description: data.description,
        iconCode: data.iconCode,
        humidity: data.humidity,
        windSpeed: data.windSpeed,
        timestamp: data.timestamp,
      );
    }
    throw Exception('날씨 데이터를 불러오지 못했습니다 (${res.statusCode})');
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherData>(
  WeatherNotifier.new,
);

// ── 5일 예보 ──────────────────────────────────────────────
final forecastProvider = FutureProvider.family<List<ForecastDay>, String>((
  ref,
  cityKo,
) async {
  final uri = _forecastUri(cityKo);
  final res = await http.get(uri).timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) return _mockForecast();

  final body = json.decode(res.body);
  final list = body['list'] as List<dynamic>;

  // 3시간 단위 데이터를 일별로 집계
  final Map<String, List<dynamic>> byDay = {};
  for (final item in list) {
    final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
    final key =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    byDay.putIfAbsent(key, () => []).add(item);
  }

  final today =
      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

  return byDay.entries.where((e) => e.key != today).take(5).map((e) {
    final items = e.value;
    final temps = items
        .map((i) => (i['main']['temp'] as num).toDouble())
        .toList();
    final noon = items.firstWhere((i) {
      final dt = DateTime.fromMillisecondsSinceEpoch((i['dt'] as int) * 1000);
      return dt.hour >= 12;
    }, orElse: () => items.first);
    final date = DateTime.parse(e.key);
    return ForecastDay(
      date: date,
      tempMaxC: temps.reduce((a, b) => a > b ? a : b),
      tempMinC: temps.reduce((a, b) => a < b ? a : b),
      iconCode: noon['weather'][0]['icon'] as String,
      description: noon['weather'][0]['description'] as String,
    );
  }).toList();
});

List<ForecastDay> _mockForecast() {
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
}

// ── 벚꽃 개화 예측 ────────────────────────────────────────
final blossomProvider = Provider<BlossomForecast>((ref) {
  final city = ref.watch(selectedCityProvider);
  return _predictBlossom(city);
});

BlossomForecast _predictBlossom(String city) {
  final now = DateTime.now();
  final year = now.year;

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
