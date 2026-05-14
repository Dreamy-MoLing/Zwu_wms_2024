# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Flutter Web 仓库管理系统（进销存），当前为纯前端 Mock 数据演示阶段，无后端、无持久化、无 API 层。

## 常用命令

```bash
flutter pub get              # 安装依赖
flutter run -d chrome        # 启动 Web 开发服务器
flutter build web --release  # 构建 Web 发布版
flutter test                 # 运行所有测试
dart format .                # 格式化代码
flutter analyze              # 静态分析
bash tools/build.sh          # 构建演示版可执行文件
bash tools/release.sh        # 打标签并触发 CI 发布
```

## 技术栈

- **框架**: Flutter Web (SDK ^3.11.5)
- **状态管理**: flutter_riverpod (^2.6.1)
- **本地化**: intl (仅用于 DateFormat)
- **Lint**: flutter_lints (^6.0.0)
- **CI/CD**: GitHub Actions → GitHub Releases

## 架构

### 状态管理 (Riverpod)

所有数据目前为内存 Mock 数据，无异步加载：

- **`StateProvider`** — 用于 `currentUserProvider`（可空 `User` 对象）
- **`StateNotifierProvider`** — 用于业务实体列表（商品、供应商、客户、采购单、销售单、用户），每个 Notifier 提供 `add/update/delete` 方法和 mock 数据初始化
- **派生 `Provider`** — 如 `isLoggedInProvider` 基于 `currentUserProvider` 计算

Provider 集中在 `lib/providers/` 目录，通过 `providers.dart` barrel 文件统一导出。

### 路由

手动路由，无 go_router/auto_route。`MainScreen` 维护 `_currentRoute` 字符串和 `Map<String, Widget> _pages`，在 `initState` 中硬编码路由映射。页面切换使用 `AnimatedSwitcher`。

### 数据模型

所有模型类不可变，使用 `@override` + `copyWith` 方法。Mock 数据在模型文件中内联定义：

- `lib/models/product.dart` — Product（含 SKU/供应商）+ mockProducts
- `lib/models/order.dart` — PurchaseOrder, SalesOrder, OrderItem, PurchaseReturn, SalesReturn + mock 数据
- `lib/models/user.dart` — User + mockUsers
- `lib/models/supplier_customer.dart` — Supplier, Customer + mock 数据
- `lib/models/warehouse.dart` — Warehouse + mockWarehouses

### 认证

纯 Mock 认证。`auth_provider.dart` 中的 `login()` 函数对比硬编码用户名密码，用户密码统一为 `'123456'`。`LoginPage` 默认填充 admin/123456。

### UI 模式

- **ConsumerWidget** — 需要订阅 provider 的页面
- **ConsumerStatefulWidget** — MainScreen（路由）和 AppLayout（响应式侧边栏）
- **StatelessWidget** — 纯展示页面（仪表盘、报表等）
- **表单**: 统一使用 `AlertDialog` + `StatefulBuilder` 内联在页面中，无独立表单组件
- **表格**: `DataTableWidget` 封装 Flutter DataTable，支持加载态和空态
- **订单状态流**: 采购订单 待审核 → 已通过 → 已完成 → 已入库（触发库存增加）；销售订单 待审核 → 已通过 → 已完成 → 已出库（触发库存扣减，审核时检查库存）
- **主题**: Material 3，种子色 `0xFF1e293b`（深石板色）
- **布局**: `AppLayout` 提供顶栏 + 响应式侧边栏，`Sidebar` 组件管理导航

### 页面模块

| 模块 | 页面 |
|------|------|
| 仪表盘 | dashboard |
| 基础数据 | 商品（含 SKU/供应商）、供应商、客户、仓库 |
| 采购 | 采购订单（含入库流程）、采购退货 |
| 销售 | 销售订单（含出库/库存检查）、销售退货 |
| 库存 | 库存查询（含出入库流水）、库存盘点 |
| 报表 | 销售报表、采购报表、库存报表（含日期筛选） |
| 系统 | 用户管理、角色管理 |

## 发布流程

1. `bash tools/release.sh` 创建 git tag 并推送
2. GitHub Actions 自动执行 `flutter build web --release`
3. 用 `@yao-pkg/pkg` 将 `tools/server.js` 编译为各平台可执行文件
4. 打包上传至 GitHub Releases

## 代码约定

- 中文 UI 文本，英文变量/函数名
- 模型类不可变 + copyWith
- 所有 lint 规则使用 `flutter_lints` 默认集（无自定义覆盖）
- 不注释代码，不写冗余 docstring
