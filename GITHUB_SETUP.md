# GitHub 配置快速开始

## 🎯 5 分钟快速配置

### 步骤 1：初始化本地仓库

```bash
cd /www/wwwroot/BlockWAUpdates

# 配置 Git 用户信息
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"

# 查看当前状态
git status
```

### 步骤 2：添加所有文件到暂存区

```bash
git add .
```

### 步骤 3：创建初始提交

```bash
git commit -m "feat: Initialize BlockWAUpdates project with GitHub Actions

- Add Theos build configuration
- Configure GitHub Actions workflows
- Add documentation and guides
- Setup automatic CI/CD pipeline"
```

### 步骤 4：在 GitHub 上创建仓库

**选项 A：使用 GitHub 网页界面**

1. 访问 https://github.com/new
2. 输入仓库名：`BlockWAUpdates`
3. 选择 **Public** 或 **Private**
4. 点击 **Create repository**
5. 不要初始化 README 或 .gitignore（已有本地文件）

**选项 B：使用 GitHub CLI**

```bash
# 如果已安装 GitHub CLI
gh repo create BlockWAUpdates --public --source=. --remote=origin --push
```

### 步骤 5：关联远程仓库

替换 `YOUR_USERNAME` 为你的 GitHub 用户名：

```bash
# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/BlockWAUpdates.git

# 或使用 SSH（如果配置了 SSH key）
git remote add origin git@github.com:YOUR_USERNAME/BlockWAUpdates.git

# 验证
git remote -v
```

### 步骤 6：推送代码

```bash
# 重命名分支为 main（如果需要）
git branch -M main

# 推送到 GitHub
git push -u origin main
```

---

## ✅ 验证设置

### 检查 GitHub Actions 已启用

1. 访问 https://github.com/YOUR_USERNAME/BlockWAUpdates
2. 点击 **Settings** → **Actions** → **General**
3. 确保以下设置：
   - ✅ **Actions permissions**: "Allow all actions and reusable workflows"
   - ✅ **Artifact and log retention**: 默认或自定义天数

### 查看工作流

1. 点击仓库顶部的 **Actions** 选项卡
2. 应该看到 3 个工作流：
   - ✅ Build BlockWAUpdates Tweak
   - ✅ Build Matrix (Multiple Targets)
   - ✅ Quick Build (Development)

---

## 🚀 第一次编译

### 方式 1：自动编译（推荐）

推送新的更改，工作流自动触发：

```bash
# 编辑文件
echo "# 更新日志" >> CHANGELOG.md

# 提交和推送
git add CHANGELOG.md
git commit -m "docs: Add changelog"
git push
```

然后访问 **Actions** 选项卡观察编译过程。

### 方式 2：手动触发

1. 访问 **Actions** → **Build BlockWAUpdates Tweak**
2. 点击 **Run workflow**
3. 选择分支（main）
4. 点击 **Run workflow**

### 方式 3：创建发布版本

```bash
# 创建版本标签
git tag -a v1.0.1 -m "Release v1.0.1"

# 推送标签（触发矩阵编译）
git push origin v1.0.1
```

---

## 📥 获取编译结果

### 从 Artifacts 下载

1. 进入完成的工作流运行
2. 向下滚动到 **Artifacts**
3. 下载：
   - `BlockWAUpdates-dylib` (dylib 文件)
   - `BlockWAUpdates-deb` (deb 安装包)

### 从 Releases 下载

仅当创建标签 (v*) 时可用：

1. 访问仓库首页
2. 点击右侧 **Releases**
3. 下载对应版本

---

## 🔐 可选：配置 SSH Key（更安全）

如果使用 SSH 推送（避免每次输入密码）：

### 生成 SSH Key

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# 按 Enter 保存到默认位置
# 创建密码（可选）
```

### 添加到 GitHub

1. 复制公钥：
```bash
cat ~/.ssh/id_ed25519.pub
```

2. 访问 https://github.com/settings/keys
3. 点击 **New SSH key**
4. 粘贴公钥，点击 **Add SSH key**

### 更新远程 URL

```bash
# 如果之前使用 HTTPS，改为 SSH
git remote set-url origin git@github.com:YOUR_USERNAME/BlockWAUpdates.git

# 测试连接
ssh -T git@github.com
```

---

## 📊 监控编译过程

### 实时日志

1. 进入正在运行的工作流
2. 点击 **build** 或 **build-matrix**
3. 查看实时日志输出

### 关键信息查找

日志中的重要部分：

```
✓ Checkout code
✓ Setup Xcode
✓ Install Theos
✓ Setup environment
✓ Build dylib          ← 关键步骤
✓ Build deb package    ← 关键步骤
✓ Upload artifacts
```

### 失败调试

如果编译失败：

1. 查看红色错误信息
2. 搜索关键词：`error:`, `failed`, `Error`
3. 查看附近的上下文
4. 常见原因：
   - Makefile 语法错误
   - 源文件缺失
   - SDK 不兼容

---

## 🎯 推荐工作流

### 日常开发

```bash
# 在 develop 分支进行开发
git checkout -b develop
git push -u origin develop

# 修改代码
# ... 编辑文件 ...

# 推送触发 quick-build
git add .
git commit -m "feat: Add new hook"
git push origin develop

# 在 GitHub 创建 Pull Request
# PR 自动触发完整编译测试
```

### 发布新版本

```bash
# 在 main 分支上合并
git checkout main
git merge develop

# 创建版本标签
git tag -a v1.0.2 -m "Release v1.0.2"

# 推送标签
git push origin main
git push origin v1.0.2

# 工作流自动：
# 1. 编译多个架构
# 2. 创建 GitHub Release
# 3. 上传编译产物
```

---

## 🆘 常见问题

### Q1: 如何修改工作流？

编辑 `.github/workflows/*.yml` 文件，推送后自动生效：

```bash
# 修改工作流
nano .github/workflows/build-tweak.yml

# 推送
git add .github/workflows/
git commit -m "ci: Update build workflow"
git push
```

### Q2: 如何禁用某个工作流？

访问 **Actions** → 选择工作流 → **三点菜单** → **Disable workflow**

### Q3: Artifacts 保存多久？

默认 30 天。可以修改工作流中的：

```yaml
retention-days: 30  # 改为需要的天数
```

### Q4: 如何下载以前编译的产物？

1. 进入 **Actions**
2. 选择之前的工作流运行
3. 向下滚动 **Artifacts**
4. 点击下载（如果未过期）

### Q5: GitHub Actions 免费吗？

- ✅ 公开仓库：完全免费，无限使用
- ⚠️ 私有仓库：每月 2000 分钟免费（足够日常开发）

---

## 📚 下一步

完成设置后：

1. ✅ 查看 [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md) - 详细工作流说明
2. ✅ 查看 [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md) - 编译说明
3. ✅ 修改代码推送，观察自动编译
4. ✅ 创建版本标签发布

---

**现在一切就绪，可以享受自动化编译了！** 🎉
