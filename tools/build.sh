#!/bin/bash
# WMS 演示版构建脚本
# 用法: bash tools/build.sh

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS_DIR="$PROJECT_DIR/tools"
DIST_DIR="$PROJECT_DIR/dist"
BUILD_DIR="$DIST_DIR/WMS-Demo-v1.0"

echo "========================================="
echo "  WMS Demo 构建脚本"
echo "========================================="

# 1. 构建 Flutter Web
echo ""
echo "[1/3] 构建 Flutter Web..."
cd "$PROJECT_DIR"
flutter build web --release

# 2. 准备发布目录
echo ""
echo "[2/3] 准备发布文件..."
rm -rf "$DIST_DIR"
mkdir -p "$BUILD_DIR"
cp -r build/web "$BUILD_DIR/web"

# 3. 编译可执行文件
echo ""
echo "[3/3] 编译可执行文件..."
cd "$TOOLS_DIR"
npx @yao-pkg/pkg . --output "$BUILD_DIR/wms-demo"

echo ""
echo "========================================="
echo "  构建完成！"
echo "  发布包位置: $BUILD_DIR"
echo "========================================="
ls -lh "$BUILD_DIR/"
