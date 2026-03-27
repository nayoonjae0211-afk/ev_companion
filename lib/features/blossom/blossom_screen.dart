import 'package:flutter/material.dart';
import '../../core/models/blossom_model.dart';
import 'widgets/spot_bottom_sheet.dart';

const _pink2 = Color(0xFFFFD6E7);
const _pink3 = Color(0xFFFF6B9D);
const _pink4 = Color(0xFFB5006E);
const _pinkCard = Color(0xFFFFE4EF);

class BlossomScreen extends StatelessWidget {
  const BlossomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(
                          '2026 벚꽃 지도',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _pink4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '지역을 탭하면 벚꽃 명소를 볼 수 있어요',
                      style: TextStyle(color: _pink3, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    // 범례
                    Row(
                      children: [
                        _Legend(color: const Color(0xFF9E9E9E), label: '개화 전'),
                        const SizedBox(width: 12),
                        _Legend(color: const Color(0xFFFFB7D0), label: '개화 중'),
                        const SizedBox(width: 12),
                        _Legend(color: _pink3, label: '만개 중'),
                        const SizedBox(width: 12),
                        _Legend(color: const Color(0xFFCCCCCC), label: '종료'),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 도시 카드 그리드
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _CityCard(
                    city: blossomCities[i],
                    onTap: () =>
                        SpotBottomSheet.show(context, blossomCities[i]),
                  ),
                  childCount: blossomCities.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 출처
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '* 웨더아이 발표자료 기준 (기후에 따라 변동 가능)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _pink3.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFFAA5070)),
        ),
      ],
    );
  }
}

class _CityCard extends StatelessWidget {
  final BlossomCity city;
  final VoidCallback onTap;

  const _CityCard({required this.city, required this.onTap});

  Color get _statusColor {
    switch (city.status) {
      case BlossomStatus.beforeBloom:
        return const Color(0xFF9E9E9E);
      case BlossomStatus.blooming:
        return const Color(0xFFFFB7D0);
      case BlossomStatus.peaking:
        return _pink3;
      case BlossomStatus.ended:
        return const Color(0xFFCCCCCC);
    }
  }

  String get _statusLabel {
    switch (city.status) {
      case BlossomStatus.beforeBloom:
        final d = city.daysUntilBloom;
        return d > 0 ? 'D-$d' : '곧 개화';
      case BlossomStatus.blooming:
        return '개화 중';
      case BlossomStatus.peaking:
        return '🌸 만개 중';
      case BlossomStatus.ended:
        return '종료';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPeaking = city.status == BlossomStatus.peaking;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _pinkCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isPeaking ? _pink3 : _pink2,
            width: isPeaking ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _pink3.withValues(alpha: isPeaking ? 0.2 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  city.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _pink4,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Text('🤍', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '개화 ${city.bloomDate.month}/${city.bloomDate.day}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAA5070),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Text('🩷', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '만개 ${city.peakDate.month}/${city.peakDate.day}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB5006E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
