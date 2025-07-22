#!/bin/bash

# OMPeak Project Git 初始化脚本
echo "🔧 Initializing Git repository for OMPeak Project..."

# 初始化Git仓库
git init

# 添加所有文件
git add .

# 创建初始提交
git commit -m "🎉 Initial commit: NestJS project with full CI/CD pipeline

Features:
- ✅ NestJS backend application  
- ✅ Docker containerization
- ✅ GitHub Actions CI/CD
- ✅ Nginx reverse proxy
- ✅ Health checks and monitoring
- ✅ Automated deployment scripts

Ready for deployment to Alibaba Cloud!"

# 设置主分支
git branch -M main

# 添加远程仓库
git remote add origin https://github.com/peakcary/ompeak-project.git

echo "🎯 Git repository initialized!"
echo "📝 Next steps:"
echo "   1. Run: git push -u origin main"
echo "   2. Configure GitHub Secrets in repository settings"
echo "   3. The first push will trigger automatic deployment!"

echo ""
echo "📋 Required GitHub Secrets:"
echo "   SERVER_HOST=47.92.236.28"
echo "   SERVER_USER=root" 
echo "   SERVER_PASSWORD=Pp--mute9257"

echo ""
echo "🚀 After setup, your API will be available at:"
echo "   - http://47.92.236.28/api"
echo "   - http://47.92.236.28/api/health"
echo "   - http://47.92.236.28/api/status"