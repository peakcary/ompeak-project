#!/bin/bash

# OMPeak Project 服务器环境配置脚本
echo "🔧 Setting up server environment for OMPeak Project..."

# 更新系统
echo "📦 Updating system packages..."
yum update -y

# 安装必要工具
echo "🛠️  Installing essential tools..."
yum install -y curl wget git nano

# 安装Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 启动Docker服务
echo "🚀 Starting Docker service..."
systemctl start docker
systemctl enable docker

# 安装Docker Compose
echo "📦 Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 创建项目目录
echo "📁 Creating project directory..."
mkdir -p /root/ompeak-project
cd /root/ompeak-project

# 配置防火墙 (如果启用)
echo "🔥 Configuring firewall..."
if systemctl is-active --quiet firewalld; then
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --permanent --add-port=443/tcp
    firewall-cmd --permanent --add-port=3000/tcp
    firewall-cmd --reload
fi

# 验证安装
echo "✅ Verifying installations..."
echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker-compose --version

echo "Git version:"
git --version

echo "🎉 Server setup completed!"
echo "📝 Next steps:"
echo "   1. Configure GitHub Secrets in your repository"
echo "   2. Push code to trigger deployment"
echo "   3. Monitor deployment logs"