# WMS - 仓库管理系统

[![Release](https://img.shields.io/github/v/release/Dreay-MoLing/wms)](https://github.com/Dreay-MoLing/wms/releases/latest)

基于 Flutter 的仓库管理移动端应用。

## 小白体验版（无需搭建环境）

如果你不想安装任何开发工具，可以直接下载预编译的演示版可执行文件。

### 下载

从 [GitHub Releases](https://github.com/Dreay-MoLing/wms/releases) 页面下载对应系统的压缩包：

| 系统 | 下载文件 |
|------|---------|
| Linux | `wms-demo-<版本>-linux.tar.gz` |
| macOS | `wms-demo-<版本>-macos.tar.gz` |
| Windows | `wms-demo-<版本>-win.zip` |

也可通过命令行一键下载最新版：

```bash
# Linux / macOS
curl -L https://github.com/Dreay-MoLing/wms/releases/latest/download/wms-demo-<version>-linux.tar.gz | tar xz

# Windows (PowerShell)
Invoke-WebRequest -Uri https://github.com/Dreay-MoLing/wms/releases/latest/download/wms-demo-<version>-win.zip -OutFile wms-demo.zip
```

### 运行

1. 解压压缩包，得到以下结构：
   ```
   wms-demo-<版本>/
   ├── wms-demo          # 可执行文件（双击运行）
   └── web/              # 网页资源（勿删）
   ```
2. **双击 `wms-demo`** 即可启动，终端窗口打开后会自动在浏览器中打开演示页面
3. 关闭终端窗口即可停止服务

> **注意：** `wms-demo` 和 `web/` 文件夹必须在同一目录下，缺一不可。

### 自行构建

如需从源码构建演示版，确保已安装 Flutter 和 Node.js：

```bash
# 构建指定版本（默认 1.0.0）
bash tools/build.sh

# 构建 1.1.0 版本
bash tools/build.sh 1.1.0

# 构建产物在 dist/WMS-Demo-v<版本>/
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
├── .github/
│   └── workflows/
│       └── release.yml      # CI/CD: 自动构建并发布到 GitHub Releases
├── lib/                     # Dart 源代码
│   ├── main.dart            # 应用入口
│   ├── models/              # 数据模型
│   ├── pages/               # 页面
│   ├── providers/           # Riverpod 状态管理
│   └── widgets/             # 可复用组件
├── tools/                   # 构建工具
│   ├── build.sh             # 本地构建脚本
│   ├── release.sh           # 发布脚本（打标签并触发 CI）
│   ├── server.js            # 演示版 HTTP 服务
│   └── package.json         # Node.js 配置
├── dist/                    # 构建输出目录
└── pubspec.yaml             # Flutter 项目配置
```

## 技术栈

| 技术 | 用途 |
|------|------|
| [Flutter](https://docs.flutter.dev/) | 跨平台 UI 框架 |
| [Riverpod](https://riverpod.dev/) | 状态管理 |
| [intl](https://pub.dev/packages/intl) | 国际化/本地化 |

## 常见问题

### 发布新版本

项目采用 GitHub Actions 自动构建并发布到 GitHub Releases：

```bash
# 1. 确保代码已提交，工作区干净

# 2. 运行发布脚本（自动读取 pubspec.yaml 中的版本号）
bash tools/release.sh

# 3. 或者手动指定版本
bash tools/release.sh 1.1.0

# 脚本会自动打标签并推送到 GitHub，随后 Actions 会自动构建并发布
```

发布后访问 [Releases 页面](https://github.com/Dreay-MoLing/wms/releases) 即可看到构建产物。

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
