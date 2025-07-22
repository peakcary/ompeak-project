#!/bin/bash

echo "🚀 OMPeak Project 手动部署脚本"
echo "============================="
echo ""

# 检查是否在项目根目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

echo "📦 1. 安装依赖"
echo "-------------"
npm install
if [ $? -ne 0 ]; then
    echo "❌ 依赖安装失败"
    exit 1
fi
echo "✅ 依赖安装完成"
echo ""

echo "🔨 2. 构建应用"
echo "-------------"
npm run build
if [ $? -ne 0 ]; then
    echo "❌ 构建失败"
    exit 1
fi
echo "✅ 应用构建完成"
echo ""

echo "🧪 3. 运行测试"
echo "-------------"
npm run test
if [ $? -ne 0 ]; then
    echo "⚠️  测试失败，但继续部署"
else
    echo "✅ 测试通过"
fi
echo ""

echo "📦 4. 构建Docker镜像"
echo "------------------"
docker build -t ompeak-project .
if [ $? -ne 0 ]; then
    echo "❌ Docker镜像构建失败"
    exit 1
fi
echo "✅ Docker镜像构建完成"
echo ""

echo "💾 5. 保存Docker镜像"
echo "------------------"
docker save ompeak-project > ompeak-project.tar
if [ $? -ne 0 ]; then
    echo "❌ Docker镜像保存失败"
    exit 1
fi
echo "✅ Docker镜像已保存为 ompeak-project.tar"
echo ""

echo "📋 6. 生成部署包"
echo "---------------"
tar -czf deployment-package.tar.gz ompeak-project.tar docker-compose.yml deploy.sh nginx.conf
if [ $? -ne 0 ]; then
    echo "❌ 部署包生成失败"
    exit 1
fi
echo "✅ 部署包已生成: deployment-package.tar.gz"
echo ""

echo "📤 7. 生成上传指令"
echo "----------------"
cat << 'EOF'
现在需要手动将部署包上传到服务器。您可以使用以下方法之一:

方法1: 使用scp上传 (如果SSH密码认证可用)
scp deployment-package.tar.gz root@47.92.236.28:/root/

方法2: 使用阿里云控制台
1. 登录阿里云ECS控制台
2. 使用Web终端或文件上传功能
3. 将 deployment-package.tar.gz 上传到服务器的 /root/ 目录

方法3: 使用其他文件传输工具
- FileZilla、WinSCP等工具
- 传输到服务器的 /root/ 目录

上传完成后，在服务器上运行:
cd /root
tar -xzf deployment-package.tar.gz
chmod +x deploy.sh
./deploy.sh
EOF

echo ""
echo "🎯 当前状态"
echo "----------"
echo "✅ 本地构建完成"
echo "✅ Docker镜像已准备"
echo "✅ 部署包已生成"
echo "⏳ 等待手动上传到服务器"
echo ""
echo "📁 生成的文件:"
echo "- ompeak-project.tar (Docker镜像)"
echo "- deployment-package.tar.gz (完整部署包)"
echo ""
echo "📞 如需技术支持，请参考: ./手动部署方案.md"