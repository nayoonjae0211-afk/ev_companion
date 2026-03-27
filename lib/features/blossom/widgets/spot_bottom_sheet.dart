import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/blossom_model.dart';
import '../../../core/providers/blossom_providers.dart';

class SpotBottomSheet extends ConsumerWidget {
  final BlossomCity city;

  const SpotBottomSheet({super.key, required this.city});

  static void show(BuildContext context, BlossomCity city) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpotBottomSheet(city: city),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotsAsync = ref.watch(spotsProvider(city.areaCode));

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF0F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // 핸들
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB7D0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${city.name} 벚꽃 명소',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB5006E),
                        ),
                      ),
                      Text(
                        '개화 ${_fmt(city.bloomDate)}  만개 ${_fmt(city.peakDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE07099),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFFFD6E7), height: 1),

            // 명소 목록
            Expanded(
              child: spotsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
                ),
                error: (e, _) => Center(
                  child: Text(
                    '명소 정보를 불러오지 못했어요\n$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFE07099)),
                  ),
                ),
                data: (spots) => spots.isEmpty
                    ? const Center(
                        child: Text(
                          '등록된 명소가 없어요 🌸',
                          style: TextStyle(color: Color(0xFFE07099)),
                        ),
                      )
                    : ListView.separated(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: spots.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: Color(0xFFFFD6E7), height: 1),
                        itemBuilder: (context, i) => _SpotTile(spot: spots[i]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.month}/${d.day}';
}

class _SpotTile extends StatelessWidget {
  final TouristSpot spot;
  const _SpotTile({required this.spot});

  Future<void> _openKakaoMap() async {
    final kakaoUri = Uri.parse(
      'kakaomap://search?q=${Uri.encodeComponent(spot.title)}',
    );
    final webUri = Uri.parse(
      'https://map.kakao.com/link/search/${Uri.encodeComponent(spot.title)}',
    );

    if (await canLaunchUrl(kakaoUri)) {
      await launchUrl(kakaoUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openKakaoMap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: spot.imageUrl != null && spot.imageUrl!.isNotEmpty
                  ? Image.network(
                      spot.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),

            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF3D0020),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spot.address.isNotEmpty ? spot.address : '주소 정보 없음',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAA5070),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 지도 아이콘
            const Icon(Icons.map_outlined, color: Color(0xFFFF6B9D), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: const Color(0xFFFFD6E7),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(Icons.local_florist, color: Color(0xFFFF6B9D)),
  );
}
