#!/bin/bash

# OMPeak Project 服务器端完整部署脚本
# 在服务器上直接运行此脚本

echo "🚀 OMPeak Project 完整部署方案"
echo "============================="
echo ""

# 1. 系统环境检查
echo "🔍 1. 检查系统环境"
echo "----------------"
echo "系统信息: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
echo "当前用户: $(whoami)"
echo "当前目录: $(pwd)"
echo ""

# 2. 安装基础依赖
echo "📦 2. 安装基础依赖"
echo "----------------"
if command -v yum &> /dev/null; then
    yum update -y
    yum install -y curl wget git nano unzip
elif command -v apt-get &> /dev/null; then
    apt-get update
    apt-get install -y curl wget git nano unzip
fi
echo "✅ 基础依赖安装完成"
echo ""

# 3. 安装Node.js
echo "🟢 3. 安装Node.js 18"
echo "------------------"
if ! command -v node &> /dev/null; then
    echo "正在安装Node.js..."
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash - 2>/dev/null
    yum install -y nodejs 2>/dev/null || (curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs)
fi
echo "Node.js版本: $(node --version 2>/dev/null || echo '未安装')"
echo "NPM版本: $(npm --version 2>/dev/null || echo '未安装')"
echo ""

# 4. 安装Docker
echo "🐳 4. 安装Docker"
echo "---------------"
if ! command -v docker &> /dev/null; then
    echo "正在安装Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    usermod -aG docker root
fi
echo "Docker版本: $(docker --version 2>/dev/null || echo '未安装')"
echo ""

# 5. 安装Nginx
echo "🌐 5. 安装和配置Nginx"
echo "-------------------"
if ! command -v nginx &> /dev/null; then
    yum install -y nginx || apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
fi

# 配置Nginx反向代理
cat > /etc/nginx/conf.d/ompeak.conf << 'EOF'
server {
    listen 80;
    server_name 47.92.236.28;

    location /api {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location / {
        proxy_pass http://127.0.0.1:3000/api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

nginx -t && systemctl reload nginx
echo "✅ Nginx配置完成"
echo ""

# 6. 防火墙配置
echo "🔥 6. 配置防火墙"
echo "---------------"
if command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --permanent --add-port=3000/tcp
    firewall-cmd --reload
    echo "✅ 防火墙配置完成 (firewalld)"
elif command -v ufw &> /dev/null; then
    ufw allow 80
    ufw allow 3000
    echo "✅ 防火墙配置完成 (ufw)"
else
    echo "⚠️  请手动确保端口80和3000开放"
fi
echo ""

# 7. 部署应用
echo "🚀 7. 部署OMPeak应用"
echo "------------------"
cd /root
rm -rf ompeak-project

echo "克隆最新代码..."
git clone https://github.com/peakcary/ompeak-project.git
cd ompeak-project

echo "安装依赖..."
npm install --production

echo "构建应用..."
npm run build

echo "启动应用..."
# 停止旧进程
pkill -f "node dist/main" 2>/dev/null || true

# 启动新进程
nohup npm run start:prod > /var/log/ompeak.log 2>&1 &
APP_PID=$!

# 等待应用启动
echo "等待应用启动..."
sleep 5

# 检查进程
if ps -p $APP_PID > /dev/null; then
    echo "✅ 应用启动成功，PID: $APP_PID"
else
    echo "❌ 应用启动失败"
    echo "错误日志:"
    tail -20 /var/log/ompeak.log
    exit 1
fi
echo ""

# 8. 健康检查
echo "🏥 8. 应用健康检查"
echo "----------------"
sleep 3
HEALTH_CHECK=$(curl -s http://127.0.0.1:3000/api/health | grep -c "OK" || echo "0")
if [ "$HEALTH_CHECK" -gt 0 ]; then
    echo "✅ 应用健康检查通过"
else
    echo "⚠️  健康检查失败，但应用可能仍在启动中"
fi
echo ""

# 9. 部署完成信息
echo "🎉 部署完成！"
echo "============"
echo ""
echo "📱 访问地址:"
echo "- 主页: http://47.92.236.28/"
echo "- API: http://47.92.236.28/api"  
echo "- 健康检查: http://47.92.236.28/api/health"
echo "- 状态监控: http://47.92.236.28/api/status"
echo ""
echo "📊 服务状态:"
echo "- 应用PID: $APP_PID"
echo "- 日志文件: /var/log/ompeak.log"
echo "- 项目目录: /root/ompeak-project"
echo ""
echo "🔧 管理命令:"
echo "- 查看日志: tail -f /var/log/ompeak.log"
echo "- 重启应用: systemctl restart ompeak || (pkill -f 'node dist/main' && cd /root/ompeak-project && nohup npm run start:prod > /var/log/ompeak.log 2>&1 &)"
echo "- 检查进程: ps aux | grep node"
echo ""
echo "✨ 部署成功完成！"