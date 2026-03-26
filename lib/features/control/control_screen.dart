import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/weather_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_strings.dart';

const _bgTop = Color(0xFF192F6E);
const _bgBottom = Color(0xFF0A1A3D);
const _cardBg = Color(0x9933549A);
const _textSub = Color(0xFFCCDEFF);

const _cities = ['서울', '부산', '제주', '대구', '인천', '광주', '대전'];

class CityScreen extends ConsumerWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);
    final blossom = ref.watch(blossomProvider);
    final s = AppStrings(ref.watch(localeProvider));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgTop, _bgBottom],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                s.citySelect,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                s.citySubtitle,
                style: const TextStyle(color: _textSub, fontSize: 14),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: _cities.map((city) {
                    final isSelected = city == selectedCity;
                    return _CityCard(
                      city: city,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(selectedCityProvider.notifier).select(city);
                        ref.read(weatherProvider.notifier).refresh();
                      },
                    );
                  }).toList(),
                ),
              ),

              // 선택 도시 벚꽃 배너
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('🌸', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$selectedCity ${s.blossomTitle}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          blossom.message,
                          style: const TextStyle(color: _textSub, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String city;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityCard({
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4D73B2)
              : _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4DC0FF) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.location_city,
              color: isSelected ? const Color(0xFF4DC0FF) : _textSub,
              size: 22,
            ),
            Text(
              city,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
