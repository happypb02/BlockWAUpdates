# 🎯 从这里开始！

## ✨ 你好！欢迎使用 BlockWAUpdates GitHub Actions 自动编译系统

### 🎉 好消息

你的项目已经完全配置好了自动化编译系统！现在只需要 3 个简单步骤就能开始使用。

---

## ⚡ 快速开始（10 分钟）

### 步骤 1️⃣：配置 Git（1 分钟）

```bash
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

### 步骤 2️⃣：提交代码（2 分钟）

```bash
git add .
git commit -m "feat: Initialize BlockWAUpdates with GitHub Actions"
```

### 步骤 3️⃣：推送到 GitHub（2 分钟）

```bash
# 用你的 GitHub 用户名替换 YOUR_USERNAME
git remote add origin https://github.com/YOUR_USERNAME/BlockWAUpdates.git
git branch -M main
git push -u origin main
```

### ✅ 完成！

访问你的 GitHub 仓库 → **Actions** 选项卡 → 观察编译过程

---

## 📚 文档导航

选择适合你的文档：

| 你的情况 | 推荐文档 | 阅读时间 |
|--------|--------|--------|
| 🆕 第一次使用 | [GITHUB_SETUP.md](./GITHUB_SETUP.md) | 10分钟 |
| 🤔 想了解更多 | [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md) | 15分钟 |
| 📖 需要完整指南 | [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md) | 30分钟 |
| ⚡ 只要快速命令 | [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) | 2分钟 |

---

## 🎯 工作流简介

创建了 **3 个自动编译工作流**：

### 1️⃣ **build-tweak.yml** - 主工作流
- 何时运行：推送代码、创建 PR、手动触发
- 做什么：编译 dylib + 打包 deb
- 输出：可下载的编译产物

### 2️⃣ **quick-build.yml** - 快速开发
- 何时运行：推送到 develop 分支
- 做什么：快速编译（带缓存）
- 输出：快速反馈

### 3️⃣ **build-matrix.yml** - 版本发布
- 何时运行：创建标签（`git tag v1.0.0`）
- 做什么：编译所有架构 + 创建 Release
- 输出：GitHub Release + 多架构二进制

---

## 💡 常见场景

### 场景 1：日常开发

```bash
# 编辑代码
nano Tweak_Modern.xm

# 提交
git add .
git commit -m "feat: Add new hook"

# 推送（自动触发编译）
git push origin develop

# 等待编译完成，从 Artifacts 下载
```

### 场景 2：发布新版本

```bash
# 创建版本标签
git tag -a v1.0.2 -m "Release v1.0.2"

# 推送标签（自动触发矩阵编译 + 创建 Release）
git push origin v1.0.2

# 完成！自动生成 Release 页面
```

### 场景 3：快速测试

```bash
# 在 GitHub Actions 页面手动触发
# Actions → Build BlockWAUpdates Tweak → Run workflow

# 或在命令行：
git commit --allow-empty -m "trigger: rebuild"
git push origin main
```

---

## ❓ 常见问题

### Q: 编译需要多长时间？
**A:** 首次 3-5 分钟，后续 1-2 分钟（感谢缓存加速）

### Q: 编译失败了怎么办？
**A:** 查看 Actions 页面的详细日志，或阅读 [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md#-故障排除)

### Q: 怎样下载编译产物？
**A:** 进入完成的工作流 → 向下滚动 → Artifacts → 下载

### Q: GitHub Actions 免费吗？
**A:** 是的！公开仓库完全免费，私有仓库每月 2000 分钟免费

### Q: 如何修改编译选项？
**A:** 编辑 `Makefile` 或 `.github/workflows/build-tweak.yml`，然后推送

---

## 📦 你会得到什么

每次编译生成：

```
✅ BlockWAUpdates.dylib    (iOS 二进制文件，两种架构)
✅ *.deb                   (Debian 安装包，可在越狱设备安装)
✅ 编译日志                (用于调试)
```

---

## 🛠️ 项目文件结构

```
BlockWAUpdates/
├── .github/workflows/          ← GitHub Actions 自动编译
│   ├── build-tweak.yml         ✨ 主工作流
│   ├── build-matrix.yml        ✨ 版本发布
│   └── quick-build.yml         ✨ 快速开发
│
├── Tweak_Modern.xm             ← 源代码（推荐）
├── Tweak.xm                    ← 源代码（备用）
├── Makefile                    ← 编译配置
├── control                     ← 包元数据
│
└── 📖 文档
    ├── START_HERE.md           ← 你在这儿！
    ├── GITHUB_SETUP.md         ← 快速配置
    ├── GITHUB_ACTIONS_SETUP.md ← 配置总结
    ├── GITHUB_ACTIONS_GUIDE.md ← 完整指南
    └── QUICK_REFERENCE.md      ← 速查表
```

---

## 🚀 下一步

### 立即做这些：

1. ✅ 按上面的"快速开始"完成 3 个步骤
2. ✅ 访问你的 GitHub 仓库 Actions 选项卡
3. ✅ 观察第一次自动编译
4. ✅ 从 Artifacts 下载编译产物
5. ✅ 庆祝成功！ 🎉

### 进阶探索：

- 🔧 自定义编译选项 → 编辑 `Makefile`
- 📦 修改源代码 → 编辑 `Tweak_Modern.xm`
- 🏷️ 创建版本发布 → 使用 `git tag`
- 📚 深入理解 → 阅读 [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md)

---

## 🆘 需要帮助？

| 问题 | 查看 |
|------|------|
| 怎么配置? | [GITHUB_SETUP.md](./GITHUB_SETUP.md) |
| 工作流如何工作? | [GITHUB_ACTIONS_GUIDE.md](./GITHUB_ACTIONS_GUIDE.md) |
| 快速命令? | [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) |
| 编译失败? | [GITHUB_ACTIONS_GUIDE.md#-故障排除](./GITHUB_ACTIONS_GUIDE.md) |
| 总体了解? | [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md) |

---

## ✨ 你现在拥有：

- ✅ 3 个配置好的 GitHub Actions 工作流
- ✅ 5 个详细的文档和指南
- ✅ 自动编译系统
- ✅ 一键版本发布
- ✅ 编译产物自动保存

---

## 🎯 记住这个命令：

```bash
git add . && git commit -m "your message" && git push
```

就这么简单！推送后，一切自动进行。

---

## 💬 最后的话

现在一切准备就绪了！

- 不需要在本地编译复杂的 iOS 项目
- 不需要安装 Xcode 和 Theos（GitHub Actions 帮你做）
- 只需推送代码，自动获得编译结果

**去享受自动化编译带来的便利吧！** 🚀

---

**有问题？** 从[GITHUB_SETUP.md](./GITHUB_SETUP.md)开始！

**准备好了？** 执行快速开始的 3 个步骤！

---

*最后更新: 2025-11-07* ✨
