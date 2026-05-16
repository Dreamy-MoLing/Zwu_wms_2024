import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

/// 企业进销存管理系统 - 统一主题数据
/// 基于 Material 3，采用设计系统规范

class AppThemeData {
  /// 亮色主题
  static ThemeData lightTheme() {
    const seedColor = AppColors.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 颜色方案
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.info,
        error: AppColors.error,
        surface: AppColors.bgPrimary,
        outline: AppColors.borderDefault,
      ),

      // 文字主题
      textTheme: AppTypography.buildTextTheme(),

      // 输入框样式
      inputDecorationTheme: _inputDecorationTheme(),

      // 按钮样式
      elevatedButtonTheme: _elevatedButtonThemeData(),
      outlinedButtonTheme: _outlinedButtonThemeData(),
      textButtonTheme: _textButtonThemeData(),

      // 图标主题
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      primaryIconTheme: const IconThemeData(color: AppColors.primary),

      // 应用栏样式
      appBarTheme: _appBarTheme(),

      // 分割线样式
      dividerTheme: _dividerTheme(),

      // 数据表格样式
      dataTableTheme: _dataTableTheme(),

      // 菜单样式
      popupMenuTheme: _popupMenuTheme(),

      // 阴影色
      shadowColor: AppColors.shadowColor,

      // 焦点色
      focusColor: AppColors.primary.withValues(alpha: 0.1),
      hoverColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.12),
    );
  }

  /// 输入框主题
  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgSecondary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      labelStyle: AppTypography.label,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textTertiary,
      ),
      helperStyle: AppTypography.caption,
      errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
    );
  }

  /// 提升按钮主题
  static ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: AppSpacing.elevationSmall,
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppSpacing.elevationNormal;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppSpacing.elevationLarge;
              }
              return AppSpacing.elevationSmall;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.bgQuaternary;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primaryLight;
              }
              return AppColors.primary;
            }),
          ),
    );
  }

  /// 轮廓按钮主题
  static OutlinedButtonThemeData _outlinedButtonThemeData() {
    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
            ),
            side: const BorderSide(color: AppColors.borderDefault),
            foregroundColor: AppColors.primary,
          ).copyWith(
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return const BorderSide(color: AppColors.primary, width: 2);
              }
              if (states.contains(WidgetState.disabled)) {
                return const BorderSide(color: AppColors.borderLight);
              }
              return const BorderSide(color: AppColors.borderDefault);
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withValues(alpha: 0.05);
              }
              return Colors.transparent;
            }),
          ),
    );
  }

  /// 文本按钮主题
  static TextButtonThemeData _textButtonThemeData() {
    return TextButtonThemeData(
      style:
          TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            foregroundColor: AppColors.primary,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withValues(alpha: 0.08);
              }
              return Colors.transparent;
            }),
          ),
    );
  }

  /// 应用栏主题
  static AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.bgPrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.md,
      toolbarHeight: AppSpacing.heightAppBar,
      surfaceTintColor: Colors.transparent,
    );
  }

  /// 分割线主题
  static DividerThemeData _dividerTheme() {
    return const DividerThemeData(
      color: AppColors.borderLight,
      thickness: AppSpacing.borderNormal,
      space: AppSpacing.md,
    );
  }

  /// 数据表格主题
  static DataTableThemeData _dataTableTheme() {
    return DataTableThemeData(
      headingRowColor: WidgetStateColor.resolveWith(
        (_) => AppColors.bgTertiary,
      ),
      dataRowColor: WidgetStateColor.resolveWith((_) => AppColors.bgPrimary),
      headingRowHeight: AppSpacing.heightTableRow,
      dataRowMinHeight: AppSpacing.heightTableRow,
      dataRowMaxHeight: AppSpacing.heightTableRow,
      dividerThickness: AppSpacing.borderNormal,
      headingTextStyle: AppTypography.h6.copyWith(color: AppColors.textPrimary),
      dataTextStyle: AppTypography.bodyMedium,
    );
  }

  /// 弹出菜单主题
  static PopupMenuThemeData _popupMenuTheme() {
    return PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
      ),
      elevation: AppSpacing.elevationLarge,
      color: AppColors.bgPrimary,
      textStyle: AppTypography.bodyMedium,
    );
  }

  /// 暗色主题
  static ThemeData darkTheme() {
    const seedColor = AppColorsDark.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // 颜色方案
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.info,
        error: AppColorsDark.error,
        surface: AppColorsDark.bgPrimary,
        outline: AppColorsDark.borderDefault,
      ),

      // 文字主题
      textTheme: AppTypography.buildTextThemeDark(),

      // 输入框样式
      inputDecorationTheme: _inputDecorationThemeDark(),

      // 按钮样式
      elevatedButtonTheme: _elevatedButtonThemeDataDark(),
      outlinedButtonTheme: _outlinedButtonThemeDataDark(),
      textButtonTheme: _textButtonThemeDataDark(),

      // 图标主题
      iconTheme: const IconThemeData(color: AppColorsDark.textSecondary),
      primaryIconTheme: const IconThemeData(color: AppColorsDark.primary),

      // 应用栏样式
      appBarTheme: _appBarThemeDark(),

      // 分割线样式
      dividerTheme: _dividerThemeDark(),

      // 数据表格样式
      dataTableTheme: _dataTableThemeDark(),

      // 菜单样式
      popupMenuTheme: _popupMenuThemeDark(),

      // 阴影色
      shadowColor: AppColorsDark.shadowColor,

      // 焦点色
      focusColor: AppColorsDark.primary.withValues(alpha: 0.1),
      hoverColor: AppColorsDark.primary.withValues(alpha: 0.08),
      highlightColor: AppColorsDark.primary.withValues(alpha: 0.12),
    );
  }

  /// 暗色输入框主题
  static InputDecorationTheme _inputDecorationThemeDark() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.bgSecondary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
        borderSide: const BorderSide(color: AppColorsDark.borderLight),
      ),
      labelStyle: AppTypography.label,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColorsDark.textTertiary,
      ),
      helperStyle: AppTypography.caption,
      errorStyle: AppTypography.caption.copyWith(color: AppColorsDark.error),
    );
  }

  /// 暗色提升按钮主题
  static ElevatedButtonThemeData _elevatedButtonThemeDataDark() {
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
            ),
            backgroundColor: AppColorsDark.primary,
            foregroundColor: Colors.white,
            elevation: AppSpacing.elevationSmall,
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppSpacing.elevationNormal;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppSpacing.elevationLarge;
              }
              return AppSpacing.elevationSmall;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColorsDark.bgQuaternary;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColorsDark.primaryLight;
              }
              return AppColorsDark.primary;
            }),
          ),
    );
  }

  /// 暗色轮廓按钮主题
  static OutlinedButtonThemeData _outlinedButtonThemeDataDark() {
    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
            ),
            side: const BorderSide(color: AppColorsDark.borderDefault),
            foregroundColor: AppColorsDark.primary,
          ).copyWith(
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return const BorderSide(color: AppColorsDark.primary, width: 2);
              }
              if (states.contains(WidgetState.disabled)) {
                return const BorderSide(color: AppColorsDark.borderLight);
              }
              return const BorderSide(color: AppColorsDark.borderDefault);
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColorsDark.primary.withValues(alpha: 0.05);
              }
              return Colors.transparent;
            }),
          ),
    );
  }

  /// 暗色文本按钮主题
  static TextButtonThemeData _textButtonThemeDataDark() {
    return TextButtonThemeData(
      style:
          TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            minimumSize: const Size(0, AppSpacing.heightButton),
            foregroundColor: AppColorsDark.primary,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColorsDark.primary.withValues(alpha: 0.08);
              }
              return Colors.transparent;
            }),
          ),
    );
  }

  /// 暗色应用栏主题
  static AppBarTheme _appBarThemeDark() {
    return const AppBarTheme(
      backgroundColor: AppColorsDark.bgPrimary,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.md,
      toolbarHeight: AppSpacing.heightAppBar,
      surfaceTintColor: Colors.transparent,
    );
  }

  /// 暗色分割线主题
  static DividerThemeData _dividerThemeDark() {
    return const DividerThemeData(
      color: AppColorsDark.borderLight,
      thickness: AppSpacing.borderNormal,
      space: AppSpacing.md,
    );
  }

  /// 暗色数据表格主题
  static DataTableThemeData _dataTableThemeDark() {
    return DataTableThemeData(
      headingRowColor: WidgetStateColor.resolveWith(
        (_) => AppColorsDark.bgTertiary,
      ),
      dataRowColor: WidgetStateColor.resolveWith((_) => AppColorsDark.bgPrimary),
      headingRowHeight: AppSpacing.heightTableRow,
      dataRowMinHeight: AppSpacing.heightTableRow,
      dataRowMaxHeight: AppSpacing.heightTableRow,
      dividerThickness: AppSpacing.borderNormal,
      headingTextStyle: AppTypography.h6.copyWith(color: AppColorsDark.textPrimary),
      dataTextStyle: AppTypography.bodyMedium,
    );
  }

  /// 暗色弹出菜单主题
  static PopupMenuThemeData _popupMenuThemeDark() {
    return PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
      ),
      elevation: AppSpacing.elevationLarge,
      color: AppColorsDark.bgPrimary,
      textStyle: AppTypography.bodyMedium,
    );
  }
}
