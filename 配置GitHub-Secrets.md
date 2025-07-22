# GitHub Secrets 配置指南

## 🎉 代码推送成功！

您的代码已经成功推送到GitHub仓库：
https://github.com/peakcary/ompeak-project

GitHub Actions 已经尝试运行，但由于缺少 Secrets 配置而失败。

## 🔐 配置 GitHub Secrets

### 步骤1：访问仓库设置
1. 打开仓库：https://github.com/peakcary/ompeak-project
2. 点击 **Settings** 选项卡
3. 在左侧菜单中选择 **Secrets and variables** → **Actions**

### 步骤2：添加部署秘钥
点击 **New repository secret**，依次添加以下三个秘钥：

#### 秘钥1: SERVER_HOST
- **Name**: `SERVER_HOST`
- **Secret**: `47.92.236.28`

#### 秘钥2: SERVER_USER  
- **Name**: `SERVER_USER`
- **Secret**: `root`

#### 秘钥3: SERVER_PASSWORD
- **Name**: `SERVER_PASSWORD`  
- **Secret**: `Pp--mute9257`

### 步骤3：触发重新部署

配置完成后，有两种方式触发部署：

#### 方式1：重新运行失败的工作流
1. 访问：https://github.com/peakcary/ompeak-project/actions
2. 点击失败的工作流
3. 点击 **Re-run all jobs**

#### 方式2：推送新的提交
```bash
cd /Users/peakom/ompeak-project
git commit --allow-empty -m "trigger deployment"
git push origin main
```

## 🚀 部署验证

部署成功后，可以访问以下地址验证：

- **主页**: http://47.92.236.28/api
- **健康检查**: http://47.92.236.28/api/health  
- **状态监控**: http://47.92.236.28/api/status

## 📊 GitHub Actions 工作流

工作流程包括：
1. **测试阶段**: 安装依赖 → 运行测试 → 构建应用
2. **部署阶段**: 构建Docker镜像 → 上传到服务器 → 自动部署

## 🔧 服务器环境配置

如果需要配置服务器环境，可以运行：

```bash
# 在服务器上运行
curl -fsSL https://raw.githubusercontent.com/peakcary/ompeak-project/main/server-setup.sh | bash
```

## ✅ 完成后的工作流

配置完成后，您的开发工作流将非常简单：

1. **本地开发**: 
   ```bash
   npm run start:dev  # 开发模式
   ```

2. **推送部署**:
   ```bash
   git add .
   git commit -m "your changes"
   git push origin main  # 自动触发部署
   ```

3. **验证部署**: 访问 http://47.92.236.28/api

🎊 恭喜！您现在有了一个完全自动化的现代Web应用部署系统！