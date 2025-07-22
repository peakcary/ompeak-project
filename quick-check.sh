#!/bin/bash

echo "🔍 OMPeak Project 快速状态检查"
echo "============================="
echo ""

# 1. 检查GitHub最新提交
echo "📝 1. GitHub 最新提交状态"
echo "-------------------------"
LATEST_COMMIT=$(git log -1 --pretty=format:"%h %s")
echo "最新提交: $LATEST_COMMIT"
echo ""

# 2. 检查GitHub Actions状态
echo "🔄 2. GitHub Actions 状态"
echo "------------------------"
ACTIONS_URL="https://github.com/peakcary/ompeak-project/actions"
echo "GitHub Actions地址: $ACTIONS_URL"

# 获取最新的Actions状态
LATEST_RUN=$(curl -s https://api.github.com/repos/peakcary/ompeak-project/actions/runs | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
LATEST_STATUS=$(curl -s https://api.github.com/repos/peakcary/ompeak-project/actions/runs | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "最新运行状态: $LATEST_STATUS"
echo "最新运行结果: $LATEST_RUN"

if [ "$LATEST_RUN" = "success" ]; then
    echo "✅ GitHub Actions 部署成功"
elif [ "$LATEST_RUN" = "failure" ]; then
    echo "❌ GitHub Actions 部署失败"
    echo "💡 请检查: $ACTIONS_URL"
    echo ""
    echo "🔧 可能的解决方案:"
    echo "1. 检查 GitHub Secrets 配置:"
    echo "   https://github.com/peakcary/ompeak-project/settings/secrets/actions"
    echo "2. 需要配置以下 Secrets:"
    echo "   - SERVER_HOST = 47.92.236.28"
    echo "   - SERVER_USER = root"
    echo "   - SERVER_PASSWORD = Pp--mute9257"
else
    echo "⏳ GitHub Actions 可能正在运行或未运行"
fi

echo ""

# 3. 检查服务器网络连通性
echo "🌐 3. 服务器连通性检查"
echo "-------------------"
if ping -c 1 47.92.236.28 > /dev/null 2>&1; then
    echo "✅ 服务器网络连通"
else
    echo "❌ 服务器网络不通"
    exit 1
fi
echo ""

# 4. 检查Web服务
echo "🌍 4. Web 服务检查"
echo "----------------"
HTTP_STATUS=$(curl -I --silent --connect-timeout 5 http://47.92.236.28 2>/dev/null | head -1 | cut -d' ' -f2)
API_STATUS=$(curl -I --silent --connect-timeout 5 http://47.92.236.28/api 2>/dev/null | head -1 | cut -d' ' -f2)

echo "根路径状态: $HTTP_STATUS"
echo "API路径状态: $API_STATUS"

if [ "$API_STATUS" = "200" ]; then
    echo "🎉 NestJS 应用已成功部署并运行！"
    echo ""
    echo "📱 可访问的地址:"
    echo "- 主页: http://47.92.236.28/api"
    echo "- 健康检查: http://47.92.236.28/api/health"
    echo "- 状态监控: http://47.92.236.28/api/status"
elif [ "$API_STATUS" = "404" ]; then
    echo "⚠️  Nginx运行，但应用未部署"
    echo "💡 需要等待GitHub Actions完成或手动部署"
elif [ "$API_STATUS" = "502" ]; then
    echo "⚠️  应用已部署但无法正常运行"
    echo "💡 可能需要检查Docker容器状态"
else
    echo "❓ 无法确定应用状态"
fi

echo ""

# 5. 提供下一步指导
echo "📋 5. 下一步操作指导"
echo "------------------"
if [ "$LATEST_RUN" = "failure" ]; then
    echo "1. 🔐 配置 GitHub Secrets (最重要):"
    echo "   访问: https://github.com/peakcary/ompeak-project/settings/secrets/actions"
    echo ""
    echo "2. 🔄 重新触发部署:"
    echo "   git commit --allow-empty -m 'retry deployment'"
    echo "   git push origin main"
    echo ""
elif [ "$API_STATUS" = "200" ]; then
    echo "🎊 部署成功！开始使用您的应用："
    echo "   curl http://47.92.236.28/api"
    echo ""
else
    echo "⏳ 等待部署完成，或检查 GitHub Actions 日志"
    echo "   $ACTIONS_URL"
fi

echo "🔍 详细诊断请查看: ./部署问题诊断.md"