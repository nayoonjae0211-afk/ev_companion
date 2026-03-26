import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ev_companion/main.dart';

void main() {
  testWidgets('앱 정상 렌더링 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WeatherApp()));

    // 비동기 로딩 대기 (mock delay 800ms)
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
