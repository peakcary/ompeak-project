#!/bin/bash

echo "🔍 OMPeak Project 部署状态检查"
echo "================================"

# 检查GitHub Actions状态
echo "📊 1. GitHub Actions 状态检查"
echo "----------------------------"
GITHUB_STATUS=$(curl -s https://api.github.com/repos/peakcary/ompeak-project/actions/runs | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
GITHUB_CONCLUSION=$(curl -s https://api.github.com/repos/peakcary/ompeak-project/actions/runs | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "GitHub Actions 状态: $GITHUB_STATUS"
echo "GitHub Actions 结果: $GITHUB_CONCLUSION"

if [ "$GITHUB_STATUS" = "completed" ] && [ "$GITHUB_CONCLUSION" = "success" ]; then
    echo "✅ GitHub Actions 部署成功"
elif [ "$GITHUB_STATUS" = "completed" ] && [ "$GITHUB_CONCLUSION" = "failure" ]; then
    echo "❌ GitHub Actions 部署失败"
    echo "💡 可能原因: GitHub Secrets 未配置"
    echo "   请访问: https://github.com/peakcary/ompeak-project/settings/secrets/actions"
else
    echo "⏳ GitHub Actions 可能正在运行中"
fi

echo ""

# 检查服务器网络连通性
echo "🌐 2. 服务器网络连通性"
echo "----------------------------"
if ping -c 3 47.92.236.28 > /dev/null 2>&1; then
    echo "✅ 服务器网络连通正常"
else
    echo "❌ 服务器网络不通"
    exit 1
fi

echo ""

# 检查Web服务状态
echo "🌐 3. Web服务状态检查"
echo "----------------------------"

# 检查根路径
ROOT_STATUS=$(curl -I --silent --connect-timeout 10 http://47.92.236.28 2>/dev/null | head -1 | cut -d' ' -f2)
echo "根路径 (http://47.92.236.28): $ROOT_STATUS"

# 检查API路径
API_STATUS=$(curl -I --silent --connect-timeout 10 http://47.92.236.28/api 2>/dev/null | head -1 | cut -d' ' -f2)
echo "API路径 (http://47.92.236.28/api): $API_STATUS"

# 检查健康检查
HEALTH_STATUS=$(curl -I --silent --connect-timeout 10 http://47.92.236.28/api/health 2>/dev/null | head -1 | cut -d' ' -f2)
echo "健康检查 (http://47.92.236.28/api/health): $HEALTH_STATUS"

echo ""

# 详细检查API响应
echo "🔍 4. API响应内容检查"
echo "----------------------------"
if [ "$API_STATUS" = "200" ]; then
    echo "✅ NestJS应用已部署并正常运行"
    echo "API响应:"
    curl -s --connect-timeout 10 http://47.92.236.28/api | head -10
    echo ""
elif [ "$API_STATUS" = "502" ]; then
    echo "❌ 应用部署了但无法正常运行 (502 Bad Gateway)"
    echo "💡 可能原因: Docker容器未启动或配置错误"
elif [ "$API_STATUS" = "404" ]; then
    echo "⚠️  Nginx运行正常，但应用未部署 (404 Not Found)"
    echo "💡 可能原因: GitHub Actions部署失败或应用未启动"
elif [ "$API_STATUS" = "" ]; then
    echo "❌ 无法连接到服务器"
    echo "💡 可能原因: 服务器防火墙或服务未启动"
else
    echo "⚠️  服务器响应状态码: $API_STATUS"
fi

echo ""

# 检查端口开放情况
echo "🔌 5. 端口开放状态"
echo "----------------------------"
nc -z -v -w5 47.92.236.28 80 2>&1 | grep -q "succeeded" && echo "✅ 端口80开放" || echo "❌ 端口80未开放"
nc -z -v -w5 47.92.236.28 3000 2>&1 | grep -q "succeeded" && echo "✅ 端口3000开放" || echo "❌ 端口3000未开放"

echo ""

# 提供解决方案
echo "🛠️  6. 问题解决建议"
echo "----------------------------"
if [ "$GITHUB_CONCLUSION" = "failure" ]; then
    echo "GitHub Actions部署失败的解决方案:"
    echo "1. 配置GitHub Secrets:"
    echo "   访问: https://github.com/peakcary/ompeak-project/settings/secrets/actions"
    echo "   添加: SERVER_HOST, SERVER_USER, SERVER_PASSWORD"
    echo "2. 重新运行部署:"
    echo "   访问: https://github.com/peakcary/ompeak-project/actions"
    echo "   点击最新的工作流，选择 'Re-run all jobs'"
    echo ""
fi

if [ "$API_STATUS" = "404" ]; then
    echo "应用未部署的解决方案:"
    echo "1. 检查并配置GitHub Secrets"
    echo "2. 手动触发部署:"
    echo "   git commit --allow-empty -m 'trigger deployment'"
    echo "   git push origin main"
    echo ""
fi

echo "🎯 验证完成后访问地址:"
echo "- 主页: http://47.92.236.28/api"
echo "- 健康检查: http://47.92.236.28/api/health"
echo "- 状态监控: http://47.92.236.28/api/status"