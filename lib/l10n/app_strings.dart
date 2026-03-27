import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  AppStrings(this.locale);

  bool get _isKo => locale.languageCode == 'ko';

  String get appTitle => _isKo ? '날씨 & 벚꽃' : 'Weather & Blossom';
  String get home => _isKo ? '날씨' : 'Weather';
  String get cityTab => _isKo ? '도시' : 'City';
  String get blossomTab => _isKo ? '벚꽃' : 'Blossom';
  String get settings => _isKo ? '설정' : 'Settings';

  // Home
  String get refresh => _isKo ? '다시 시도' : 'Retry';
  String get high => _isKo ? '최고' : 'H';
  String get low => _isKo ? '최저' : 'L';
  String get humidity => _isKo ? '습도' : 'Humidity';
  String get wind => _isKo ? '바람' : 'Wind';
  String get feelsLike => _isKo ? '체감' : 'Feels like';
  String get forecast => _isKo ? '5일 예보' : '5-Day Forecast';

  // Blossom
  String get blossomTitle => _isKo ? '벚꽃 개화' : 'Cherry Blossom';

  // City
  String get citySelect => _isKo ? '도시 선택' : 'Select City';
  String get citySubtitle =>
      _isKo ? '날씨를 확인할 도시를 선택하세요' : 'Choose a city to check the weather';

  // Settings
  String get language => _isKo ? '언어' : 'Language';
  String get languageValue => _isKo ? '한국어' : 'English';
  String get switchLanguage => _isKo ? '영어로 전환' : 'Switch to Korean';
  String get appVersion => _isKo ? '앱 버전' : 'App Version';
  String get aboutApp => _isKo ? '앱 정보' : 'About';
  String get aboutDesc => _isKo ? 'HMG 포트폴리오 프로젝트' : 'HMG Portfolio Project';
  String get dataSource => _isKo ? '데이터 출처' : 'Data Source';
}
