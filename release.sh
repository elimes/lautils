#!/bin/bash
# release.sh - 同时更新 .data/VERSION 和 pyproject.toml

set -e  # 出错立即退出

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 0.1.1" >&2
  exit 1
fi

echo "🚀 Releasing version v$VERSION..."

# 1. 切换并同步 main 分支
git checkout main
git pull origin main --tags

# 2. 更新权威版本文件
echo "$VERSION" > .data/VERSION
echo "✅ Updated .data/VERSION"

# 3. 同步到 pyproject.toml
sed -i "s/^version = .*/version = \"$VERSION\"/" pyproject.toml
echo "✅ Updated pyproject.toml"

# 4. 提交
git add .data/VERSION pyproject.toml
git commit -m "chore: release v$VERSION"
git tag "v$VERSION"

# 5. 推送
git push origin main
git push origin "v$VERSION"

echo "🎉 Release v$VERSION triggered! Check GitHub Actions."
