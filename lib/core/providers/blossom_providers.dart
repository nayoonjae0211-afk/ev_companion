import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/blossom_model.dart';
import '../services/tour_api_service.dart';

final tourApiServiceProvider = Provider((_) => TourApiService());

/// 선택된 도시의 명소 목록
final spotsProvider = FutureProvider.family<List<TouristSpot>, String>((
  ref,
  areaCode,
) async {
  final service = ref.read(tourApiServiceProvider);
  return service.fetchBlossomSpots(areaCode);
});
