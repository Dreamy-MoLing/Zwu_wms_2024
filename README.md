# WMS - 仓库管理系统

基于 Flutter 的仓库管理移动端应用。

## 小白体验版（无需搭建环境）

如果你不想安装任何开发工具，只想在浏览器中体验效果，可以直接使用预编译的演示版：

### 下载与运行

1. 从 `dist/WMS-Demo-v1.0/` 目录获取发布包
2. 发布包内含两个文件：

   ```
   WMS-Demo-v1.0/
   ├── wms-demo        # 可执行文件（双击运行）
   └── web/            # 网页资源（勿删）
   ```

3. **双击 `wms-demo`** 即可启动，终端窗口打开后会自动在浏览器中打开演示页面
4. 关闭终端窗口即可停止服务

> **注意：** `wms-demo` 和 `web/` 文件夹必须在同一目录下，缺一不可。
>
> **Windows 用户：** 需要安装 [Node.js](https://nodejs.org/) 后，在终端中运行 `node server.js` 启动（Windows 版后续可编译）。

### 自行构建演示版

如需重新构建演示版，确保已安装 Flutter 和 Node.js，然后运行：

```bash
# 一键构建
bash tools/build.sh

# 构建产物在 dist/WMS-Demo-v1.0/
```

---

## 开发者指南

以下内容面向需要修改代码的开发者。

### 环境要求

| 工具 | 版本要求 | 说明 |
|------|---------|------|
| Flutter | >= 3.11.5 | 跨平台框架 |
| Dart | >= 3.11.5 | Flutter 内置，安装 Flutter 时自动包含 |

### 环境搭建

**Linux / macOS / WSL：**

```bash
# 下载 Flutter SDK
git clone https://github.com/flutter/flutter.git ~/flutter

# 加入 PATH（添加到 ~/.bashrc 或 ~/.zshrc）
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 验证安装
flutter doctor
```

**Windows：** 参考 [Flutter 官方文档](https://docs.flutter.dev/get-started/install/windows) 安装。

> `flutter doctor` 如有红色错误提示，按提示修复即可。

### 快速开始

```bash
# 1. 进入项目目录
cd wms

# 2. 安装依赖
flutter pub get

# 3. 以 Web 方式启动
flutter run -d chrome
```

### 常用命令

```bash
flutter clean              # 清理构建缓存
flutter pub get            # 重新安装依赖
dart format .              # 格式化代码
flutter test               # 运行测试
flutter build web --release # 构建 Web 发布版
```

## 项目结构

```
wms/
├── lib/                   # Dart 源代码
│   ├── main.dart          # 应用入口
│   ├── models/            # 数据模型
│   ├── pages/             # 页面
│   ├── providers/         # Riverpod 状态管理
│   └── widgets/           # 可复用组件
├── tools/                 # 构建工具
│   ├── build.sh           # 一键构建脚本
│   ├── server.js          # 演示版 HTTP 服务
│   └── package.json       # Node.js 配置
├── dist/                  # 构建输出目录
└── pubspec.yaml           # Flutter 项目配置
```

## 技术栈

| 技术 | 用途 |
|------|------|
| [Flutter](https://docs.flutter.dev/) | 跨平台 UI 框架 |
| [Riverpod](https://riverpod.dev/) | 状态管理 |
| [intl](https://pub.dev/packages/intl) | 国际化/本地化 |

## 常见问题

### `flutter pub get` 下载慢

设置国内镜像代理：

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### `flutter run` 找不到设备

- Web 版指定 Chrome 运行：`flutter run -d chrome`
- 或者构建后直接在浏览器打开：`flutter build web --release`，然后用任意 HTTP 服务器托管 `build/web/` 目录

### Dart SDK 版本不匹配

运行 `flutter upgrade` 升级 Flutter 和 Dart SDK。

## 参考资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Flutter 中文网](https://flutter.cn/)
- [Riverpod 中文文档](https://riverpod.dev/zh/)
- [Dart 语言导览](https://dart.dev/language)
