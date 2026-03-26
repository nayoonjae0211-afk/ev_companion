import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/locale_provider.dart';
import 'features/home/home_screen.dart';
import 'features/control/control_screen.dart';
import 'features/settings/settings_screen.dart';
import 'l10n/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ProviderScope(child: WeatherApp()));
}

class WeatherApp extends ConsumerWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Weather & Blossom',
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF192F6E),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xDD0A1A3D),
          indicatorColor: Color(0x554DC0FF),
        ),
      ),
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  static const _screens = [
    HomeScreen(),
    CityScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(ref.watch(localeProvider));

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.wb_sunny_outlined, color: Color(0xFFCCDEFF)),
            selectedIcon: const Icon(Icons.wb_sunny, color: Color(0xFF4DC0FF)),
            label: s.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_city_outlined, color: Color(0xFFCCDEFF)),
            selectedIcon: const Icon(Icons.location_city, color: Color(0xFF4DC0FF)),
            label: s.cityTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFFCCDEFF)),
            selectedIcon: const Icon(Icons.settings, color: Color(0xFF4DC0FF)),
            label: s.settings,
          ),
        ],
      ),
    );
  }
}
