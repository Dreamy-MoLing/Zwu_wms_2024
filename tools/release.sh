#!/bin/bash
# WMS 发布脚本：打标签并推送，触发 GitHub Actions 自动构建与发布
# 用法: bash tools/release.sh [版本号]
# 示例: bash tools/release.sh                   # 从 pubspec.yaml 读取版本
#       bash tools/release.sh 1.1.0             # 指定版本

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

# 确定版本号
if [ -n "$1" ]; then
  VERSION="$1"
else
  VERSION=$(grep '^version: ' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
fi

TAG="v${VERSION}"

# 确认
echo "版本: $VERSION"
echo "标签:  $TAG"
echo "发布说明将基于 $TAG 与上一个标签之间的提交自动生成。"
echo ""
read -r -p "确认发布？[y/N] " reply
case "$reply" in
  [yY]) ;;
  *) echo "已取消"; exit 1 ;;
esac

# 确保工作区干净
if [ -n "$(git status --porcelain)" ]; then
  echo "错误：工作区有未提交的更改，请先提交或暂存。" >&2
  exit 1
fi

# 打标签并推送
git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"

echo ""
echo "✅ 标签 $TAG 已推送！"
echo "   GitHub Actions 将自动构建并发布到："
echo "   https://github.com/${GITHUB_REPOSITORY:-$(git remote get-url origin | sed 's/.*:\(.*\)\.git/\1/')}/releases/tag/$TAG"
