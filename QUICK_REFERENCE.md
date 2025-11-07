# 🚀 快速参考卡

## 📝 初始化（仅一次）

```bash
# 1. 配置用户信息
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"

# 2. 创建初始提交
git add .
git commit -m "Initial commit: BlockWAUpdates with GitHub Actions"

# 3. 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/BlockWAUpdates.git
git branch -M main
git push -u origin main
```

## 🔄 日常工作流

```bash
# 编辑代码
nano Tweak_Modern.xm

# 提交更改
git add .
git commit -m "feat: Your changes"
git push origin main

# 或推送到 develop 分支（快速编译）
git push origin develop
```

## 🏷️ 发布版本

```bash
# 创建版本标签
git tag -a v1.0.2 -m "Release v1.0.2"

# 推送标签（自动触发矩阵编译和发布）
git push origin v1.0.2
```

## 📊 监控编译

```
GitHub 仓库 → Actions → 选择工作流 → 查看日志
```

## 📥 下载编译产物

```
完成的工作流运行 → Artifacts → 下载
```

## 🔧 编译工作流

| 工作流 | 触发条件 | 用途 |
|-------|--------|------|
| build-tweak.yml | push/PR/手动 | 标准编译 |
| quick-build.yml | push to develop | 快速迭代 |
| build-matrix.yml | tag v* | 多架构发布 |

## ⚡ 快速命令

```bash
git status              # 查看状态
git log --oneline       # 查看提交历史
git tag -l              # 列出所有标签
git remote -v           # 查看远程仓库
```

## 📚 详细文档

- **快速开始**: [GITHUB_SETUP.md](./GITHUB_SETUP.md)
- **完整指南**: [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md)
- **配置总结**: [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md)
- **编译说明**: [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)

---

**更多帮助请查阅完整文档！**
