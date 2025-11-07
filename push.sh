#!/bin/bash

# BlockWAUpdates GitHub 推送脚本
# 用法: ./push.sh [branch]
# 默认分支: main

set -e

BRANCH="${1:-main}"
REPO="https://github.com/happypb2/BlockWAUpdates.git"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║          BlockWAUpdates - GitHub 推送脚本                    ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# 验证配置
echo "📋 验证 Git 配置..."
USER_NAME=$(git config user.name)
USER_EMAIL=$(git config user.email)
REMOTE_URL=$(git config --get remote.origin.url)
CURRENT_BRANCH=$(git branch --show-current)

echo "  用户名: $USER_NAME"
echo "  邮箱: $USER_EMAIL"
echo "  远程仓库: $REMOTE_URL"
echo "  当前分支: $CURRENT_BRANCH"
echo ""

# 检查配置是否正确
if [ "$USER_NAME" != "happypb2" ]; then
    echo "⚠️  警告: 用户名不是 happypb2，是 $USER_NAME"
fi

if [ "$USER_EMAIL" != "predty@qq.com" ]; then
    echo "⚠️  警告: 邮箱不是 predty@qq.com，是 $USER_EMAIL"
fi

# 显示待推送的提交
echo "📝 待推送的提交:"
git log origin/${BRANCH}..${BRANCH} --oneline 2>/dev/null || git log --oneline -5

echo ""
echo "🔄 开始推送到 GitHub..."
echo "  分支: $BRANCH"
echo "  仓库: $REPO"
echo ""

# 推送
git push -u origin ${BRANCH}

if [ $? -eq 0 ]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║                  ✅ 推送成功！                                ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "🎉 接下来:"
    echo "  1. 访问: https://github.com/happypb2/BlockWAUpdates"
    echo "  2. 点击 'Actions' 选项卡"
    echo "  3. 等待 GitHub Actions 编译完成（3-5 分钟）"
    echo "  4. 从 Artifacts 下载 dylib 和 deb 文件"
    echo ""
else
    echo ""
    echo "❌ 推送失败！"
    echo "请检查:"
    echo "  • 网络连接"
    echo "  • GitHub 凭证"
    echo "  • 仓库权限"
    exit 1
fi
