import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ev_companion/core/providers/weather_provider.dart';
import 'package:ev_companion/core/models/weather_model.dart';

void main() {
  group('selectedCityProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('초기 도시는 서울', () {
      expect(container.read(selectedCityProvider), '서울');
    });

    test('도시 변경', () {
      container.read(selectedCityProvider.notifier).state = '부산';
      expect(container.read(selectedCityProvider), '부산');
    });
  });

  group('blossomProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('서울 벚꽃 예측 반환', () {
      final blossom = container.read(blossomProvider);
      expect(blossom.cityName, '서울');
      expect(blossom.status, isA<BlossomStatus>());
      expect(blossom.message, isNotEmpty);
    });

    test('도시 변경 시 벚꽃 정보도 변경', () {
      container.read(selectedCityProvider.notifier).state = '제주';
      final blossom = container.read(blossomProvider);
      expect(blossom.cityName, '제주');
    });

    test('예측 날짜가 null이 아님', () {
      final blossom = container.read(blossomProvider);
      expect(blossom.predictedDate, isNotNull);
    });
  });

  group('forecastProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('5일 예보 반환', () {
      final forecast = container.read(forecastProvider);
      expect(forecast.length, 5);
    });

    test('예보 날짜가 오늘 이후', () {
      final forecast = container.read(forecastProvider);
      final today = DateTime.now();
      for (final day in forecast) {
        expect(day.date.isAfter(today), true);
      }
    });
  });
}
