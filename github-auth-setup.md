# GitHub 认证配置指南

## 问题说明

当前遇到的问题：
- 本地Git配置用户名与GitHub用户名不匹配
- 缺少GitHub认证配置

## 解决步骤

### 方法1：使用Personal Access Token (推荐)

#### 1. 生成GitHub Token
1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置Token描述：`ompeak-project-deploy`
4. 选择权限：
   - ✅ `repo` (完整仓库权限)
   - ✅ `workflow` (GitHub Actions权限)
5. 点击 "Generate token"
6. **复制Token** (只显示一次，请保存好)

#### 2. 配置Git使用Token
在终端中运行：

```bash
cd /Users/peakom/ompeak-project

# 设置远程URL使用Token
git remote set-url origin https://peakcary:YOUR_TOKEN_HERE@github.com/peakcary/ompeak-project.git

# 推送代码
git push -u origin main
```

### 方法2：使用GitHub CLI

```bash
# 安装GitHub CLI
brew install gh

# 登录GitHub
gh auth login

# 推送代码
git push -u origin main
```

### 方法3：使用SSH密钥

#### 1. 生成SSH密钥
```bash
ssh-keygen -t ed25519 -C "peakcary@163.com"
# 按回车使用默认路径
# 可以设置密码或直接回车
```

#### 2. 添加SSH密钥到GitHub
```bash
# 复制公钥
cat ~/.ssh/id_ed25519.pub
# 复制输出的内容

# 在GitHub添加SSH密钥：
# https://github.com/settings/ssh/new
```

#### 3. 修改远程URL使用SSH
```bash
git remote set-url origin git@github.com:peakcary/ompeak-project.git
git push -u origin main
```

## 推荐使用方法1 (Personal Access Token)

最简单快捷的方式：
1. 生成Token：https://github.com/settings/tokens
2. 复制Token
3. 运行命令：
   ```bash
   git remote set-url origin https://peakcary:YOUR_TOKEN@github.com/peakcary/ompeak-project.git
   git push -u origin main
   ```

## 验证推送成功

推送成功后，访问GitHub仓库查看代码是否已上传：
https://github.com/peakcary/ompeak-project

同时GitHub Actions会自动开始部署流程！