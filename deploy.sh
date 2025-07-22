#!/bin/bash

# OMPeak Project 部署脚本
echo "🚀 Starting deployment..."

# 设置变量
PROJECT_DIR="/root/ompeak-project"
IMAGE_NAME="ompeak-project"
CONTAINER_NAME="ompeak-project"

# 进入项目目录
cd $PROJECT_DIR

# 停止并删除旧容器
echo "📦 Stopping existing containers..."
docker-compose down --remove-orphans

# 删除旧镜像
echo "🗑️  Cleaning up old images..."
docker rmi $IMAGE_NAME:latest 2>/dev/null || true

# 加载新镜像
echo "📥 Loading new Docker image..."
docker load < ompeak-project.tar

# 启动新容器
echo "🔄 Starting new containers..."
docker-compose up -d

# 等待应用启动
echo "⏳ Waiting for application to start..."
sleep 30

# 健康检查
echo "🔍 Performing health check..."
for i in {1..10}; do
    if curl -f http://localhost:3000/api/health >/dev/null 2>&1; then
        echo "✅ Application is healthy!"
        break
    else
        echo "⏳ Waiting for application... ($i/10)"
        sleep 5
    fi
    
    if [ $i -eq 10 ]; then
        echo "❌ Health check failed!"
        docker-compose logs ompeak-app
        exit 1
    fi
done

# 清理旧文件
echo "🧹 Cleaning up deployment files..."
rm -f ompeak-project.tar

# 显示部署状态
echo "📊 Deployment Status:"
docker-compose ps

echo "🎉 Deployment completed successfully!"
echo "🌐 Application is running at:"
echo "   - API: http://47.92.236.28/api"
echo "   - Health: http://47.92.236.28/api/health"
echo "   - Status: http://47.92.236.28/api/status"