import 'package:flutter/material.dart';

/// 企业进销存管理系统 - 间距系统
/// 基于 8px 倍数规范，统一应用于 padding、margin、尺寸等

class AppSpacing {
  // ============ 基础间距单位 ============
  /// 最小间距（4px）
  static const double xs = 4;

  /// 小间距（8px）
  static const double sm = 8;

  /// 标准间距（16px）
  static const double md = 16;

  /// 大间距（24px）
  static const double lg = 24;

  /// 超大间距（32px）
  static const double xl = 32;

  /// 极大间距（48px）
  static const double xxl = 48;

  /// 特大间距（64px）
  static const double xxxl = 64;

  // ============ 常用组合 ============

  /// 容器内边距 - 紧凑
  static const double paddingTight = md;

  /// 容器内边距 - 标准
  static const double paddingNormal = lg;

  /// 容器内边距 - 宽松
  static const double paddingLoose = xl;

  /// 元素间距 - 紧凑
  static const double gapTight = sm;

  /// 元素间距 - 标准
  static const double gapNormal = md;

  /// 元素间距 - 宽松
  static const double gapLoose = lg;

  // ============ 圆角规范 ============
  /// 不圆角
  static const double radiusNone = 0;

  /// 小圆角（4px）
  static const double radiusSmall = 4;

  /// 标准圆角（8px）
  static const double radiusNormal = 8;

  /// 大圆角（12px）
  static const double radiusLarge = 12;

  /// 特大圆角（16px）
  static const double radiusXL = 16;

  /// 完全圆形
  static const double radiusFull = 999;

  // ============ 高度和宽度规范 ============

  /// 紧凑按钮高度
  static const double heightButtonSmall = 32;

  /// 标准按钮高度
  static const double heightButton = 40;

  /// 大按钮高度
  static const double heightButtonLarge = 48;

  /// 输入框高度
  static const double heightInput = 40;

  /// 表格行高
  static const double heightTableRow = 48;

  /// 表格行高（紧凑）
  static const double heightTableRowCompact = 40;

  /// 菜单项高度
  static const double heightMenuItem = 40;

  /// 顶部栏高度
  static const double heightAppBar = 64;

  /// 底部栏高度
  static const double heightBottomBar = 56;

  /// 侧边栏宽度
  static const double widthSidebar = 240;

  /// 侧边栏宽度（折叠）
  static const double widthSidebarCollapsed = 64;

  /// 卡片最大宽度
  static const double widthCardMax = 400;

  /// 对话框最大宽度
  static const double widthDialogMax = 600;

  // ============ 阴影定义 ============

  /// 浅阴影（卡片、按钮 hover）
  static const double elevationSmall = 1;

  /// 标准阴影（默认卡片）
  static const double elevationNormal = 2;

  /// 深阴影（下拉菜单、对话框）
  static const double elevationLarge = 4;

  /// 特深阴影（模态框、弹窗）
  static const double elevationXL = 8;

  // ============ 边框厚度 ============
  /// 细边框
  static const double borderThin = 1;

  /// 标准边框
  static const double borderNormal = 1;

  /// 粗边框
  static const double borderThick = 2;

  // ============ 动画时长 ============
  /// 快速动画（100ms）
  static const Duration animationFast = Duration(milliseconds: 100);

  /// 标准动画（200ms）
  static const Duration animationNormal = Duration(milliseconds: 200);

  /// 缓慢动画（300ms）
  static const Duration animationSlow = Duration(milliseconds: 300);

  /// 很慢动画（500ms）
  static const Duration animationVerySlow = Duration(milliseconds: 500);

  // ============ 便捷方法 ============

  /// 获取对称间距 EdgeInsets
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// 获取所有边间距 EdgeInsets
  static EdgeInsets all(double value) {
    return EdgeInsets.all(value);
  }

  /// 获取仅顶部间距
  static EdgeInsets onlyTop(double value) {
    return EdgeInsets.only(top: value);
  }

  /// 获取仅底部间距
  static EdgeInsets onlyBottom(double value) {
    return EdgeInsets.only(bottom: value);
  }

  /// 获取仅左边间距
  static EdgeInsets onlyLeft(double value) {
    return EdgeInsets.only(left: value);
  }

  /// 获取仅右边间距
  static EdgeInsets onlyRight(double value) {
    return EdgeInsets.only(right: value);
  }
}

extension EdgeInsetsExt on EdgeInsets {
  /// 创建按照间距系统的 EdgeInsets
  static EdgeInsets get symmetric8 =>
      const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm);
  static EdgeInsets get symmetric16 =>
      const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md);
  static EdgeInsets get symmetric24 =>
      const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg);
}
