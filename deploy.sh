#!/bin/bash
# AI Daily News 部署脚本（本地测试用）
# 生产环境请使用 GitHub Actions 自动部署

set -e

SITE_DIR="/root/.openclaw/workspace/ai-daily-news"

cd "$SITE_DIR"

echo "🚀 开始本地部署..."

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

echo "✅ 本地提交完成！"
echo ""
echo "⚠️  推送到 GitHub 需要 Token，请选择以下方式之一："
echo ""
echo "1️⃣  手动推送（推荐）："
echo "   cd $SITE_DIR"
echo "   git push"
echo ""
echo "2️⃣  使用环境变量："
echo "   export GITHUB_TOKEN=\"你的 token\""
echo "   ./deploy.sh"
echo ""
echo "3️⃣  使用 GitHub Actions（已配置）："
echo "   推送后会自动部署到 GitHub Pages"
echo ""
echo "🌐 GitHub Pages 地址：https://Zaynxxii.github.io/ai-daily-news/"
