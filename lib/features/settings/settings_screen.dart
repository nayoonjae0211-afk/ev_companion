import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_strings.dart';

const _bgTop = Color(0xFF192F6E);
const _bgBottom = Color(0xFF0A1A3D);
const _cardBg = Color(0x9933549A);
const _textSub = Color(0xFFCCDEFF);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeProvider.notifier);
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
                s.settings,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              _Section(
                children: [
                  _SettingsTile(
                    icon: Icons.language,
                    title: s.language,
                    subtitle: s.languageValue,
                    trailing: GestureDetector(
                      onTap: localeNotifier.toggle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4D73B2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s.switchLanguage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _Section(
                children: [
                  _SettingsTile(
                    icon: Icons.cloud_outlined,
                    title: s.dataSource,
                    subtitle: 'OpenWeatherMap API',
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: s.aboutApp,
                    subtitle: s.aboutDesc,
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _SettingsTile(
                    icon: Icons.tag,
                    title: s.appVersion,
                    subtitle: '1.0.0',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4DC0FF), size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: _textSub, fontSize: 13),
      ),
      trailing: trailing,
    );
  }
}
