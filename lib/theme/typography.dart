import 'package:flutter/material.dart';
import 'colors.dart';
import 'colors.dart';

/// 企业进销存管理系统 - 排版系统
/// 基于 8px 基础单位，规范化字体层级和权重

class AppTypography {
  // ============ 字体定义 ============
  /// 基础字体族
  static const String fontFamily = 'Roboto';

  /// 中文备用字体（如果需要）
  static const List<String> fontFamilyFallback = [
    'Roboto',
    'PingFang SC',
    'Microsoft YaHei',
  ];

  // ============ 字号规范（基于 8px 倍数） ============
  static const double fontSize10 = 10;
  static const double fontSize12 = 12;
  static const double fontSize13 = 13;
  static const double fontSize14 = 14;
  static const double fontSize16 = 16;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;
  static const double fontSize24 = 24;
  static const double fontSize28 = 28;
  static const double fontSize32 = 32;

  // ============ 字重规范 ============
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  // ============ 行高规范（1.5x 比例） ============
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // ============ 文本样式定义 ============

  /// H1 - 大标题（首页标题等）
  static const TextStyle h1 = TextStyle(
    fontSize: fontSize32,
    fontWeight: weightBold,
    height: lineHeightTight,
    color: AppColors.textPrimary,
  );

  /// H2 - 页面标题
  static const TextStyle h2 = TextStyle(
    fontSize: fontSize28,
    fontWeight: weightBold,
    height: lineHeightTight,
    color: AppColors.textPrimary,
  );

  /// H3 - 模块标题
  static const TextStyle h3 = TextStyle(
    fontSize: fontSize24,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    color: AppColors.textPrimary,
  );

  /// H4 - 卡片标题
  static const TextStyle h4 = TextStyle(
    fontSize: fontSize20,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// H5 - 小标题
  static const TextStyle h5 = TextStyle(
    fontSize: fontSize18,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// H6 - 表格列标题
  static const TextStyle h6 = TextStyle(
    fontSize: fontSize14,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// Body Large - 正文大
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSize16,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// Body Medium - 正文（默认）
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSize14,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// Body Small - 正文小
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSize13,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: AppColors.textSecondary,
  );

  /// Caption - 说明文字
  static const TextStyle caption = TextStyle(
    fontSize: fontSize12,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: AppColors.textSecondary,
  );

  /// Caption Small - 小说明
  static const TextStyle captionSmall = TextStyle(
    fontSize: fontSize10,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    color: AppColors.textTertiary,
  );

  /// Label - 标签和按钮文本
  static const TextStyle label = TextStyle(
    fontSize: fontSize14,
    fontWeight: weightMedium,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  /// Label Small - 小标签
  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSize12,
    fontWeight: weightMedium,
    height: lineHeightNormal,
    color: AppColors.textSecondary,
  );

  // ============ 文本主题生成 ============
  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      headlineMedium: h4,
      headlineSmall: h5,
      titleMedium: h6,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelMedium: label,
      labelSmall: labelSmall,
    );
  }

  // ============ 文本样式辅助方法 ============

  /// 创建副标题文本样式
  static TextStyle subtitle({
    double fontSize = fontSize14,
    FontWeight fontWeight = weightRegular,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeightNormal,
      color: AppColors.textSecondary,
    );
  }

  /// 创建禁用文本样式
  static TextStyle disabled(TextStyle baseStyle) {
    return baseStyle.copyWith(color: AppColors.textDisabled);
  }

  /// 创建强调文本样式
  static TextStyle emphasis(TextStyle baseStyle) {
    return baseStyle.copyWith(fontWeight: weightSemiBold);
  }

  /// 构建暗色主题文本主题
  static TextTheme buildTextThemeDark() {
    return TextTheme(
      displayLarge: h1.copyWith(color: AppColorsDark.textPrimary),
      displayMedium: h2.copyWith(color: AppColorsDark.textPrimary),
      displaySmall: h3.copyWith(color: AppColorsDark.textPrimary),
      headlineLarge: h3.copyWith(color: AppColorsDark.textPrimary),
      headlineMedium: h4.copyWith(color: AppColorsDark.textPrimary),
      headlineSmall: h5.copyWith(color: AppColorsDark.textPrimary),
      titleMedium: h6.copyWith(color: AppColorsDark.textPrimary),
      bodyLarge: bodyLarge.copyWith(color: AppColorsDark.textPrimary),
      bodyMedium: bodyMedium.copyWith(color: AppColorsDark.textSecondary),
      bodySmall: bodySmall.copyWith(color: AppColorsDark.textTertiary),
      labelMedium: label.copyWith(color: AppColorsDark.textPrimary),
      labelSmall: labelSmall.copyWith(color: AppColorsDark.textTertiary),
    );
  }
}
