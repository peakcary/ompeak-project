# OMPeak Project

🚀 基于 NestJS 的现代化 Web 应用，支持 Docker 容器化部署和 GitHub Actions 自动化 CI/CD。

## 项目特性

- 🏗️ **NestJS Framework** - 现代化的 Node.js 后端框架
- 🐳 **Docker 支持** - 完整的容器化解决方案
- 🔄 **CI/CD 自动化** - GitHub Actions 自动部署到阿里云
- 🔍 **健康检查** - 内置应用状态监控
- 🌐 **Nginx 反向代理** - 高性能 Web 服务器配置
- 📊 **API 监控** - 完整的 API 状态和健康检查接口

## 快速开始

### 本地开发

```bash
# 克隆项目
git clone https://github.com/peakcary/ompeak-project.git
cd ompeak-project

# 安装依赖
npm install

# 开发模式启动
npm run start:dev

# 访问应用
# API: http://localhost:3000/api
# 健康检查: http://localhost:3000/api/health
```

### Docker 运行

```bash
# 构建镜像
npm run docker:build

# 运行容器
npm run docker:run

# 或使用 Docker Compose
docker-compose up -d
```

## API 接口

### 基础接口

| 端点 | 方法 | 描述 | 响应 |
|------|------|------|------|
| `/api` | GET | 应用信息 | 服务状态和基本信息 |
| `/api/health` | GET | 健康检查 | 系统健康状态 |
| `/api/status` | GET | 运行状态 | 部署和运行状态 |

### 响应示例

#### GET `/api`
```json
{
  "message": "🎉 OMPeak Project API is running!",
  "service": "NestJS Backend",
  "version": "1.0.0",
  "environment": "production",
  "timestamp": "2025-01-15T10:30:00.000Z",
  "endpoints": {
    "status": "/api/status",
    "health": "/api/health"
  }
}
```

#### GET `/api/health`
```json
{
  "status": "OK",
  "uptime": 3600,
  "timestamp": "2025-01-15T10:30:00.000Z",
  "memory": {
    "rss": 45678912,
    "heapTotal": 20971520,
    "heapUsed": 15728640
  },
  "version": "v18.19.0"
}
```

## 部署指南

### 服务器环境配置

在阿里云服务器上运行以下命令：

```bash
# 下载并运行服务器配置脚本
curl -fsSL https://raw.githubusercontent.com/peakcary/ompeak-project/main/server-setup.sh | bash

# 或手动执行
chmod +x server-setup.sh
./server-setup.sh
```

### GitHub Actions 配置

在 GitHub 仓库中配置以下 Secrets：

```
SERVER_HOST=47.92.236.28
SERVER_USER=root
SERVER_PASSWORD=你的服务器密码
```

配置路径：`Settings` → `Secrets and variables` → `Actions` → `New repository secret`

### 自动部署流程

1. **推送代码** - 推送到 `main` 或 `master` 分支触发部署
2. **构建测试** - 自动运行测试和构建
3. **Docker 构建** - 创建生产环境镜像
4. **服务器部署** - 自动部署到阿里云服务器
5. **健康检查** - 验证部署是否成功

### 手动部署

如需手动部署：

```bash
# 在服务器上
cd /root/ompeak-project
git pull origin main
docker-compose down
docker-compose up -d --build
```

## 开发指南

### 项目结构

```
ompeak-project/
├── src/                    # 源代码
│   ├── app.controller.ts   # 控制器
│   ├── app.service.ts      # 服务层
│   ├── app.module.ts       # 模块配置
│   ├── main.ts            # 应用入口
│   └── health-check.ts    # 健康检查脚本
├── test/                  # 测试文件
├── .github/workflows/     # GitHub Actions
├── docker-compose.yml     # Docker Compose 配置
├── Dockerfile            # Docker 镜像配置
├── nginx.conf            # Nginx 配置
├── deploy.sh             # 部署脚本
└── server-setup.sh       # 服务器配置脚本
```

### 开发命令

```bash
# 开发
npm run start:dev          # 开发模式启动（热重载）
npm run start:debug        # 调试模式启动

# 构建
npm run build              # 构建生产版本
npm run prebuild           # 清理构建目录

# 测试
npm run test               # 单元测试
npm run test:e2e           # 端到端测试
npm run test:cov           # 测试覆盖率

# 代码质量
npm run lint               # 代码检查
npm run format             # 代码格式化
```

### 环境变量

```bash
NODE_ENV=production        # 运行环境
PORT=3000                 # 服务端口
```

## 监控和维护

### 应用监控

```bash
# 检查容器状态
docker-compose ps

# 查看应用日志
docker-compose logs -f ompeak-app

# 查看 Nginx 日志
docker-compose logs -f nginx

# 系统资源监控
docker stats
```

### 健康检查

应用内置健康检查端点：

- **本地**: `http://localhost:3000/api/health`
- **生产**: `http://47.92.236.28/api/health`

Docker 容器自动进行健康检查，不健康的容器将自动重启。

### 故障排除

常见问题解决方案：

1. **容器启动失败**
   ```bash
   docker-compose logs ompeak-app
   docker-compose restart ompeak-app
   ```

2. **端口占用**
   ```bash
   netstat -tlnp | grep :3000
   docker-compose down
   docker-compose up -d
   ```

3. **镜像构建失败**
   ```bash
   docker system prune -a
   docker-compose build --no-cache
   ```

## 技术栈

- **后端框架**: NestJS v11
- **运行时**: Node.js v18
- **容器化**: Docker & Docker Compose
- **反向代理**: Nginx
- **CI/CD**: GitHub Actions
- **云服务**: 阿里云 ECS

## 许可证

MIT License

## 支持

如有问题或需要支持，请：

1. 查看项目 [Issues](https://github.com/peakcary/ompeak-project/issues)
2. 提交新的 Issue
3. 查看部署日志进行故障排除

---

🎉 **部署成功后可访问**：
- **API**: http://47.92.236.28/api
- **健康检查**: http://47.92.236.28/api/health
- **状态监控**: http://47.92.236.28/api/status