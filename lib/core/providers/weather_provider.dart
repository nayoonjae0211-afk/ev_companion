import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/weather_model.dart';

const _waBase = 'https://api.weatherapi.com/v1/forecast.json';

const _cityQuery = {
  '서울': 'Seoul',
  '부산': 'Busan',
  '인천': 'Incheon',
  '대구': 'Daegu',
  '대전': 'Daejeon',
  '광주': 'Gwangju',
  '울산': 'Ulsan',
  '수원': 'Suwon',
  '창원': 'Changwon',
  '전주': 'Jeonju',
  '청주': 'Cheongju',
  '제주': 'Jeju',
  '포항': 'Pohang',
  '경주': 'Gyeongju',
  '여수': 'Yeosu',
  '순천': 'Suncheon',
  '목포': 'Mokpo',
  '강릉': 'Gangneung',
  '춘천': 'Chuncheon',
  '속초': 'Sokcho',
  '안동': 'Andong',
  '진주': 'Jinju',
  '통영': 'Tongyeong',
  '세종': 'Sejong',
  '천안': 'Cheonan',
};

Uri _weatherUri(String cityKo) {
  final q = _cityQuery[cityKo] ?? cityKo;
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
  return Uri.parse(_waBase).replace(
    queryParameters: {
      'key': ApiKeys.weatherApi,
      'q': q,
      'lang': 'ko',
      'days': '6',
      'aqi': 'no',
      'alerts': 'no',
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
      return WeatherData.fromWeatherApi(json.decode(res.body), city);
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
  final uri = _weatherUri(cityKo);
  final res = await http.get(uri).timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) return _mockForecast();

  final body = json.decode(res.body);
  final days = body['forecast']?['forecastday'] as List<dynamic>?;
  if (days == null) return _mockForecast();

  final today = DateTime.now();
  final todayStr =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

  return days.where((d) => (d['date'] as String) != todayStr).take(5).map((d) {
    final day = d['day'] as Map<String, dynamic>;
    final condition = day['condition'] as Map<String, dynamic>;
    return ForecastDay(
      date: DateTime.parse(d['date'] as String),
      tempMaxC: (day['maxtemp_c'] as num).toDouble(),
      tempMinC: (day['mintemp_c'] as num).toDouble(),
      iconCode: condition['icon'] as String,
      description: condition['text'] as String,
    );
  }).toList();
});

List<ForecastDay> _mockForecast() {
  final today = DateTime.now();
  return List.generate(5, (i) {
    final day = today.add(Duration(days: i + 1));
    final temps = [16.0, 18.0, 14.0, 12.0, 17.0];
    final descs = ['구름 조금', '맑음', '비', '흐림', '맑음'];
    return ForecastDay(
      date: day,
      tempMaxC: temps[i],
      tempMinC: temps[i] - 5,
      iconCode: '',
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
    '제주': (month: 3, day: 17),
    '부산': (month: 3, day: 25),
    '대구': (month: 3, day: 28),
    '포항': (month: 3, day: 25),
    '울산': (month: 3, day: 25),
    '경주': (month: 3, day: 25),
    '통영': (month: 3, day: 24),
    '여수': (month: 3, day: 26),
    '순천': (month: 3, day: 27),
    '광주': (month: 3, day: 28),
    '목포': (month: 3, day: 29),
    '전주': (month: 3, day: 26),
    '진주': (month: 3, day: 28),
    '창원': (month: 3, day: 26),
    '대전': (month: 3, day: 30),
    '청주': (month: 3, day: 30),
    '세종': (month: 3, day: 31),
    '서울': (month: 4, day: 1),
    '강릉': (month: 4, day: 1),
    '수원': (month: 4, day: 3),
    '인천': (month: 4, day: 4),
    '안동': (month: 4, day: 2),
    '춘천': (month: 4, day: 4),
    '서산': (month: 4, day: 6),
    '천안': (month: 4, day: 1),
    '속초': (month: 4, day: 3),
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
