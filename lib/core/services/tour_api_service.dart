import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/blossom_model.dart';

class TourApiService {
  static const _mobileBase = 'https://apis.data.go.kr/B551011/KorService2';

  /// 지역 기반 벚꽃 명소 조회 (관광지 타입)
  Future<List<TouristSpot>> fetchBlossomSpots(String areaCode) async {
    // 1차: 키워드 "벚꽃"으로 해당 지역 검색
    final spots = await _searchByKeyword(areaCode, '벚꽃');
    if (spots.isNotEmpty) return spots;

    // 2차: 공원/자연 카테고리로 대체
    return _searchByArea(areaCode);
  }

  Future<List<TouristSpot>> _searchByKeyword(
    String areaCode,
    String keyword,
  ) async {
    final Uri uri;
    if (kIsWeb) {
      uri = Uri(
        path: '/api/tour',
        queryParameters: {
          'type': 'keyword',
          'areaCode': areaCode,
          'keyword': keyword,
        },
      );
    } else {
      uri = Uri.parse('$_mobileBase/searchKeyword2').replace(
        queryParameters: {
          'serviceKey': ApiKeys.tourApi,
          'numOfRows': '10',
          'pageNo': '1',
          'MobileOS': 'AND',
          'MobileApp': 'EvCompanion',
          '_type': 'json',
          'keyword': keyword,
          'areaCode': areaCode,
          'contentTypeId': '12',
        },
      );
    }

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return [];
      return _parse(res.body);
    } catch (_) {
      return [];
    }
  }

  Future<List<TouristSpot>> _searchByArea(String areaCode) async {
    final Uri uri;
    if (kIsWeb) {
      uri = Uri(
        path: '/api/tour',
        queryParameters: {'type': 'area', 'areaCode': areaCode},
      );
    } else {
      uri = Uri.parse('$_mobileBase/areaBasedList2').replace(
        queryParameters: {
          'serviceKey': ApiKeys.tourApi,
          'numOfRows': '10',
          'pageNo': '1',
          'MobileOS': 'AND',
          'MobileApp': 'EvCompanion',
          '_type': 'json',
          'areaCode': areaCode,
          'contentTypeId': '12',
          'cat2': 'A0101', // 자연 > 자연관광지
        },
      );
    }

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return [];
      return _parse(res.body);
    } catch (_) {
      return [];
    }
  }

  List<TouristSpot> _parse(String body) {
    final json = jsonDecode(body);
    final items =
        json['response']?['body']?['items']?['item'] as List<dynamic>?;
    if (items == null) return [];
    return items
        .map((e) => TouristSpot.fromJson(e as Map<String, dynamic>))
        .where((s) => s.title.isNotEmpty)
        .toList();
  }
}
