import 'package:flutter/material.dart';

/// 企业进销存管理系统 - 色彩系统
/// 基于 Material Design 3 规范，采用现代极简风格

class AppColors {
  // ============ 主色调 ============
  /// 深石板色 - 品牌主色
  static const Color primary = Color(0xFF1e293b);

  /// 主色浅调 - 用于悬停、焦点状态
  static const Color primaryLight = Color(0xFF334155);

  /// 主色极浅 - 用于背景、禁用状态
  static const Color primaryLightest = Color(0xFFf1f5f9);

  // ============ 功能色 ============
  /// 成功 - 绿色系
  static const Color success = Color(0xFF16a34a);
  static const Color successLight = Color(0xFFdcfce7);
  static const Color successBorder = Color(0xFFbbf7d0);

  /// 警告 - 橙色系
  static const Color warning = Color(0xFFea580c);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFfde68a);

  /// 错误 - 红色系
  static const Color error = Color(0xFFdc2626);
  static const Color errorLight = Color(0xFFfecaca);
  static const Color errorBorder = Color(0xFFfca5a5);

  /// 信息 - 蓝色系
  static const Color info = Color(0xFF0284c7);
  static const Color infoLight = Color(0xFFbae6fd);
  static const Color infoBorder = Color(0xFF7dd3fc);

  // ============ 中性色 ============
  /// 文本色
  static const Color textPrimary = Color(0xFF1f2937);
  static const Color textSecondary = Color(0xFF6b7280);
  static const Color textTertiary = Color(0xFF9ca3af);
  static const Color textDisabled = Color(0xFFd1d5db);

  /// 背景色
  static const Color bgPrimary = Color(0xFFffffff);
  static const Color bgSecondary = Color(0xFFf9fafb);
  static const Color bgTertiary = Color(0xFFf3f4f6);
  static const Color bgQuaternary = Color(0xFFe5e7eb);

  /// 边框色
  static const Color borderLight = Color(0xFFe5e7eb);
  static const Color borderDefault = Color(0xFFd1d5db);
  static const Color borderDark = Color(0xFF9ca3af);

  // ============ 状态指示色 ============
  /// 已完成
  static const Color completed = success;

  /// 待审核
  static const Color pending = warning;

  /// 已取消
  static const Color cancelled = error;

  /// 进行中
  static const Color inProgress = info;

  // ============ 特殊色 ============
  /// 覆盖层（用于模态框、菜单）
  static const Color scrimDark = Color(0x1f000000);

  /// 分割线
  static const Color divider = Color(0xFFe5e7eb);

  /// 阴影（用于卡片、下拉菜单）
  static const shadowColor = Color(0x0d000000);

  // ============ 调色板辅助 ============
  /// 获取状态色
  static Color getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' || 'done' => success,
      'pending' => warning,
      'cancelled' || 'failed' => error,
      'in_progress' => info,
      _ => textSecondary,
    };
  }

  /// 获取状态背景色
  static Color getStatusBgColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' || 'done' => successLight,
      'pending' => warningLight,
      'cancelled' || 'failed' => errorLight,
      'in_progress' => infoLight,
      _ => bgTertiary,
    };
  }
}

/// 暗色主题色彩系统
class AppColorsDark {
  // ============ 主色调 ============
  /// 亮灰蓝 - 暗色主色
  static const Color primary = Color(0xFF64748b);

  /// 主色浅调 - 用于悬停、焦点状态
  static const Color primaryLight = Color(0xFF94a3b8);

  /// 主色极浅 - 用于背景、禁用状态
  static const Color primaryLightest = Color(0xFF1a202c);

  // ============ 功能色 ============
  /// 成功 - 绿色系
  static const Color success = Color(0xFF4ade80);
  static const Color successLight = Color(0xFF166534);
  static const Color successBorder = Color(0xFF22c55e);

  /// 警告 - 橙色系
  static const Color warning = Color(0xFFfbbf24);
  static const Color warningLight = Color(0xFF78350f);
  static const Color warningBorder = Color(0xFFf59e0b);

  /// 错误 - 红色系
  static const Color error = Color(0xFFf87171);
  static const Color errorLight = Color(0xFF7f1d1d);
  static const Color errorBorder = Color(0xFFef4444);

  /// 信息 - 蓝色系
  static const Color info = Color(0xFF38bdf8);
  static const Color infoLight = Color(0xFF0c2d48);
  static const Color infoBorder = Color(0xFF0ea5e9);

  // ============ 中性色 ============
  /// 文本色
  static const Color textPrimary = Color(0xFFf1f5f9);
  static const Color textSecondary = Color(0xFFcbd5e1);
  static const Color textTertiary = Color(0xFF94a3b8);
  static const Color textDisabled = Color(0xFF64748b);

  /// 背景色
  static const Color bgPrimary = Color(0xFF0f172a);
  static const Color bgSecondary = Color(0xFF1a1f3a);
  static const Color bgTertiary = Color(0xFF1e293b);
  static const Color bgQuaternary = Color(0xFF334155);

  /// 边框色
  static const Color borderLight = Color(0xFF334155);
  static const Color borderDefault = Color(0xFF475569);
  static const Color borderDark = Color(0xFF64748b);

  // ============ 状态指示色 ============
  /// 已完成
  static const Color completed = success;

  /// 待审核
  static const Color pending = warning;

  /// 已取消
  static const Color cancelled = error;

  /// 进行中
  static const Color inProgress = info;

  // ============ 特殊色 ============
  /// 覆盖层（用于模态框、菜单）
  static const Color scrimDark = Color(0x3f000000);

  /// 分割线
  static const Color divider = Color(0xFF334155);

  /// 阴影（用于卡片、下拉菜单）
  static const shadowColor = Color(0x1f000000);

  // ============ 调色板辅助 ============
  /// 获取状态色
  static Color getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' || 'done' => success,
      'pending' => warning,
      'cancelled' || 'failed' => error,
      'in_progress' => info,
      _ => textSecondary,
    };
  }

  /// 获取状态背景色
  static Color getStatusBgColor(String status) {
    return switch (status.toLowerCase()) {
      'completed' || 'done' => successLight,
      'pending' => warningLight,
      'cancelled' || 'failed' => errorLight,
      'in_progress' => infoLight,
      _ => bgTertiary,
    };
  }
}
