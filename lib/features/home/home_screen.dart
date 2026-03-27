import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/weather_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/models/weather_model.dart';
import '../../l10n/app_strings.dart';

const _weatherCities = ['서울', '부산', '제주', '대구', '인천', '광주', '대전'];

class _CityDropdown extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCityProvider);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _weatherCities.contains(selected) ? selected : _weatherCities[0],
        dropdownColor: const Color(0xFF1A3070),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white70,
          size: 18,
        ),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        items: _weatherCities
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (city) {
          if (city == null) return;
          ref.read(selectedCityProvider.notifier).select(city);
          ref.read(weatherProvider.notifier).refresh();
        },
      ),
    );
  }
}

// Figma 디자인 기준 색상
const _bgTop = Color(0xFF192F6E);
const _bgBottom = Color(0xFF0A1A3D);
const _cardBg = Color(0x9933549A);
const _textSub = Color(0xFFCCDEFF);
const _barBg = Color(0xFF4D73B2);
const _barFg = Color(0xFF4DC0FF);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final city = ref.watch(selectedCityProvider);
    final forecastAsync = ref.watch(forecastProvider(city));
    final forecast = forecastAsync.value ?? [];
    final blossom = ref.watch(blossomProvider);
    final s = AppStrings(ref.watch(localeProvider));

    return Scaffold(
      body: weatherAsync.when(
        loading: () => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgTop, _bgBottom],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        error: (e, _) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgTop, _bgBottom],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.white54,
                ),
                const SizedBox(height: 8),
                Text('$e', style: const TextStyle(color: Colors.white70)),
                TextButton(
                  onPressed: () => ref.read(weatherProvider.notifier).refresh(),
                  child: Text(
                    s.refresh,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (weather) => _WeatherBody(
          weather: weather,
          forecast: forecast,
          blossom: blossom,
          strings: s,
          onRefresh: () => ref.read(weatherProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

class _WeatherBody extends StatelessWidget {
  final WeatherData weather;
  final List<ForecastDay> forecast;
  final BlossomForecast blossom;
  final AppStrings strings;
  final Future<void> Function() onRefresh;

  const _WeatherBody({
    required this.weather,
    required this.forecast,
    required this.blossom,
    required this.strings,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgTop, _bgBottom],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.white,
        backgroundColor: _bgTop,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: false,
              floating: true,
              title: _CityDropdown(),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: onRefresh,
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── 상단 날씨 메인 ──
                  _MainWeatherSection(weather: weather),
                  const SizedBox(height: 24),

                  // ── 벚꽃 개화 배너 ──
                  _BlossomBanner(blossom: blossom),
                  const SizedBox(height: 16),

                  // ── 시간별 예보 카드 ──
                  _HourlyCard(weather: weather),
                  const SizedBox(height: 16),

                  // ── 주간 예보 카드 ──
                  _WeeklyCard(forecast: forecast, strings: strings),
                  const SizedBox(height: 16),

                  // ── 하단 2×2 상세 정보 ──
                  _DetailGrid(weather: weather, strings: strings),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────
// 메인 날씨 섹션
// ────────────────────────────────────────────
class _MainWeatherSection extends StatelessWidget {
  final WeatherData weather;
  const _MainWeatherSection({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 도시명
        Text(
          weather.cityName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        // 대형 기온
        Text(
          '${weather.tempC.round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 92,
            fontWeight: FontWeight.w200,
            height: 1.0,
          ),
        ),
        // 날씨 상태
        Text(
          weather.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        // 최고/최저
        Text(
          '최고: ${weather.tempMaxC.round()}°  최저: ${weather.tempMinC.round()}°',
          style: const TextStyle(color: _textSub, fontSize: 16),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────
// 벚꽃 배너
// ────────────────────────────────────────────
class _BlossomBanner extends StatelessWidget {
  final BlossomForecast blossom;
  const _BlossomBanner({required this.blossom});

  @override
  Widget build(BuildContext context) {
    final isBlooming = blossom.status == BlossomStatus.blooming;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isBlooming ? const Color(0x99FF6B9D) : const Color(0x553355AA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBlooming ? const Color(0xFFFF6B9D) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text('🌸', style: TextStyle(fontSize: isBlooming ? 28 : 22)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '벚꽃 개화 예측',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                blossom.message,
                style: const TextStyle(color: _textSub, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 시간별 예보 카드
// ────────────────────────────────────────────
class _HourlyCard extends StatelessWidget {
  final WeatherData weather;
  const _HourlyCard({required this.weather});

  static const _hourly = [
    (time: '지금', icon: '☀️', temp: '18°'),
    (time: '13시', icon: '🌤', temp: '20°'),
    (time: '14시', icon: '⛅', temp: '22°'),
    (time: '15시', icon: '🌥', temp: '21°'),
    (time: '16시', icon: '🌦', temp: '19°'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '시간별 예보',
            style: TextStyle(
              color: _textSub,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _hourly
                .map(
                  (d) => _HourlySlot(time: d.time, icon: d.icon, temp: d.temp),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HourlySlot extends StatelessWidget {
  final String time, icon, temp;
  const _HourlySlot({
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: _textSub, fontSize: 12)),
        const SizedBox(height: 6),
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(
          temp,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────
// 주간 예보 카드
// ────────────────────────────────────────────
class _WeeklyCard extends StatelessWidget {
  final List<ForecastDay> forecast;
  final AppStrings strings;
  const _WeeklyCard({required this.forecast, required this.strings});

  static const _weekData = [
    (day: '오늘', icon: '☀️', low: '12°', high: '23°', pct: 0.9),
    (day: '내일', icon: '🌤', low: '11°', high: '21°', pct: 0.75),
    (day: '토요일', icon: '🌦', low: '9°', high: '18°', pct: 0.58),
    (day: '일요일', icon: '⛅', low: '10°', high: '19°', pct: 0.65),
    (day: '월요일', icon: '☀️', low: '13°', high: '24°', pct: 0.92),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '10일간의 예보',
            style: TextStyle(
              color: _textSub,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 4),
          ..._weekData.asMap().entries.map((e) {
            final i = e.key;
            final d = e.value;
            return Column(
              children: [
                _WeekRow(
                  day: d.day,
                  icon: d.icon,
                  low: d.low,
                  high: d.high,
                  pct: d.pct,
                ),
                if (i < _weekData.length - 1)
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final String day, icon, low, high;
  final double pct;
  const _WeekRow({
    required this.day,
    required this.icon,
    required this.low,
    required this.high,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              day,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          SizedBox(
            width: 34,
            child: Text(
              low,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFF99BFFF), fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(height: 6, color: _barBg),
                  FractionallySizedBox(
                    widthFactor: pct,
                    child: Container(height: 6, color: _barFg),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 38,
            child: Text(
              high,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 하단 2×2 상세 정보 그리드
// ────────────────────────────────────────────
class _DetailGrid extends StatelessWidget {
  final WeatherData weather;
  final AppStrings strings;
  const _DetailGrid({required this.weather, required this.strings});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: '💧',
        label: strings.humidity,
        value: '${weather.humidity}%',
        sub: '이슬점: 11°',
      ),
      (
        icon: '💨',
        label: strings.wind,
        value: weather.windSpeed.toStringAsFixed(0),
        sub: 'km/h  서풍',
      ),
      (icon: '🌞', label: '자외선 지수', value: '3', sub: '보통'),
      (icon: '👁', label: '가시거리', value: '10', sub: 'km  맑음'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: items
          .map(
            (d) => _DetailTile(
              icon: d.icon,
              label: d.label,
              value: d.value,
              sub: d.sub,
            ),
          )
          .toList(),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String icon, label, value, sub;
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$icon $label',
            style: const TextStyle(
              color: _textSub,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          Text(sub, style: const TextStyle(color: _textSub, fontSize: 12)),
        ],
      ),
    );
  }
}
