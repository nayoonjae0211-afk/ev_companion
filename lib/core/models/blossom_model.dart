enum BlossomStatus { beforeBloom, blooming, peaking, ended }

class BlossomCity {
  final String name;
  final DateTime bloomDate; // 개화일
  final DateTime peakDate; // 만개일
  final String areaCode; // TourAPI 지역코드

  const BlossomCity({
    required this.name,
    required this.bloomDate,
    required this.peakDate,
    required this.areaCode,
  });

  BlossomStatus get status {
    final now = DateTime.now();
    final endDate = peakDate.add(const Duration(days: 5));
    if (now.isBefore(bloomDate)) return BlossomStatus.beforeBloom;
    if (now.isBefore(peakDate)) return BlossomStatus.blooming;
    if (now.isBefore(endDate)) return BlossomStatus.peaking;
    return BlossomStatus.ended;
  }

  int get daysUntilBloom => bloomDate.difference(DateTime.now()).inDays;
}

class TouristSpot {
  final String title;
  final String address;
  final String? imageUrl;
  final double? lat;
  final double? lng;
  final String contentId;

  const TouristSpot({
    required this.title,
    required this.address,
    this.imageUrl,
    this.lat,
    this.lng,
    required this.contentId,
  });

  factory TouristSpot.fromJson(Map<String, dynamic> json) {
    return TouristSpot(
      title: json['title'] as String? ?? '',
      address:
          '${json['addr1'] ?? ''}${json['addr2'] != null && json['addr2'] != '' ? ' ${json['addr2']}' : ''}',
      imageUrl: json['firstimage'] as String?,
      lat: double.tryParse(json['mapy']?.toString() ?? ''),
      lng: double.tryParse(json['mapx']?.toString() ?? ''),
      contentId: json['contentid']?.toString() ?? '',
    );
  }
}

// 2026 벚꽃 개화 데이터 (웨더아이 기준)
final List<BlossomCity> blossomCities = [
  BlossomCity(
    name: '제주',
    bloomDate: DateTime(2026, 3, 22),
    peakDate: DateTime(2026, 3, 29),
    areaCode: '39',
  ),
  BlossomCity(
    name: '통영',
    bloomDate: DateTime(2026, 3, 24),
    peakDate: DateTime(2026, 3, 31),
    areaCode: '36',
  ),
  BlossomCity(
    name: '부산',
    bloomDate: DateTime(2026, 3, 23),
    peakDate: DateTime(2026, 3, 30),
    areaCode: '6',
  ),
  BlossomCity(
    name: '대구',
    bloomDate: DateTime(2026, 3, 24),
    peakDate: DateTime(2026, 3, 31),
    areaCode: '4',
  ),
  BlossomCity(
    name: '포항',
    bloomDate: DateTime(2026, 3, 25),
    peakDate: DateTime(2026, 4, 1),
    areaCode: '35',
  ),
  BlossomCity(
    name: '경주',
    bloomDate: DateTime(2026, 3, 25),
    peakDate: DateTime(2026, 4, 1),
    areaCode: '35',
  ),
  BlossomCity(
    name: '울산',
    bloomDate: DateTime(2026, 3, 25),
    peakDate: DateTime(2026, 4, 1),
    areaCode: '7',
  ),
  BlossomCity(
    name: '창원',
    bloomDate: DateTime(2026, 3, 26),
    peakDate: DateTime(2026, 4, 2),
    areaCode: '36',
  ),
  BlossomCity(
    name: '전주',
    bloomDate: DateTime(2026, 3, 26),
    peakDate: DateTime(2026, 4, 2),
    areaCode: '37',
  ),
  BlossomCity(
    name: '여수',
    bloomDate: DateTime(2026, 3, 26),
    peakDate: DateTime(2026, 4, 2),
    areaCode: '38',
  ),
  BlossomCity(
    name: '진주',
    bloomDate: DateTime(2026, 3, 28),
    peakDate: DateTime(2026, 4, 4),
    areaCode: '36',
  ),
  BlossomCity(
    name: '순천',
    bloomDate: DateTime(2026, 3, 27),
    peakDate: DateTime(2026, 4, 3),
    areaCode: '38',
  ),
  BlossomCity(
    name: '광주',
    bloomDate: DateTime(2026, 3, 27),
    peakDate: DateTime(2026, 4, 3),
    areaCode: '5',
  ),
  BlossomCity(
    name: '목포',
    bloomDate: DateTime(2026, 3, 29),
    peakDate: DateTime(2026, 4, 5),
    areaCode: '38',
  ),
  BlossomCity(
    name: '대전',
    bloomDate: DateTime(2026, 3, 29),
    peakDate: DateTime(2026, 4, 5),
    areaCode: '3',
  ),
  BlossomCity(
    name: '청주',
    bloomDate: DateTime(2026, 3, 30),
    peakDate: DateTime(2026, 4, 6),
    areaCode: '33',
  ),
  BlossomCity(
    name: '세종',
    bloomDate: DateTime(2026, 3, 31),
    peakDate: DateTime(2026, 4, 7),
    areaCode: '8',
  ),
  BlossomCity(
    name: '서울',
    bloomDate: DateTime(2026, 4, 1),
    peakDate: DateTime(2026, 4, 8),
    areaCode: '1',
  ),
  BlossomCity(
    name: '강릉',
    bloomDate: DateTime(2026, 4, 1),
    peakDate: DateTime(2026, 4, 8),
    areaCode: '32',
  ),
  BlossomCity(
    name: '안동',
    bloomDate: DateTime(2026, 4, 2),
    peakDate: DateTime(2026, 4, 9),
    areaCode: '35',
  ),
  BlossomCity(
    name: '수원',
    bloomDate: DateTime(2026, 4, 3),
    peakDate: DateTime(2026, 4, 10),
    areaCode: '31',
  ),
  BlossomCity(
    name: '속초',
    bloomDate: DateTime(2026, 4, 3),
    peakDate: DateTime(2026, 4, 10),
    areaCode: '32',
  ),
  BlossomCity(
    name: '인천',
    bloomDate: DateTime(2026, 4, 4),
    peakDate: DateTime(2026, 4, 11),
    areaCode: '2',
  ),
  BlossomCity(
    name: '춘천',
    bloomDate: DateTime(2026, 4, 4),
    peakDate: DateTime(2026, 4, 11),
    areaCode: '32',
  ),
  BlossomCity(
    name: '서산',
    bloomDate: DateTime(2026, 4, 6),
    peakDate: DateTime(2026, 4, 13),
    areaCode: '34',
  ),
];
