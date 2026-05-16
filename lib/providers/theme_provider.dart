import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题模式枚举
enum ThemeMode { light, dark }

/// 主题模式提供者
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// 是否为暗色主题
final isDarkThemeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark;
});
