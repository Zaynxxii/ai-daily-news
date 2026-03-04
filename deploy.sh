#!/bin/bash
# AI Daily News 部署脚本

set -e

SITE_DIR="/root/.openclaw/workspace/ai-daily-news"
GITHUB_USER="Zaynxxii"
GITHUB_TOKEN="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"
REPO_NAME="ai-daily-news"

cd "$SITE_DIR"

echo "🚀 开始部署到 GitHub Pages..."

# 配置 git
git config user.email "openclaw@local"
git config user.name "OpenClaw"

# 添加所有文件
git add -A

# 检查是否有更改
if git diff --staged --quiet; then
    echo "ℹ️  没有更改，跳过部署"
    exit 0
fi

# 提交
DATE=$(date +"%Y-%m-%d %H:%M")
git commit -m "📰 更新 AI Daily News - $DATE"

# 推送到 GitHub
REMOTE_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
git push "$REMOTE_URL" main

echo "✅ 部署完成！"
echo "🌐 访问：https://${GITHUB_USER}.github.io/${REPO_NAME}/"
