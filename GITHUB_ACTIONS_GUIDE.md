# GitHub Actions 自动编译指南

## 概述

此项目配置了三个 GitHub Actions 工作流，可以自动编译 BlockWAUpdates tweak 为 iOS dylib。

## ✨ 工作流说明

### 1. **build-tweak.yml** (主工作流 - 推荐)

**触发条件**：
- ✅ 推送到 `main`, `master`, `develop` 分支
- ✅ 创建 Pull Request
- ✅ 手动触发 (workflow_dispatch)

**功能**：
- 编译 dylib（arm64/arm64e）
- 打包为 deb 包
- 上传编译产物（保留 30 天）
- 支持标签自动发布

**使用场景**：
- 日常开发和测试编译
- 提交 PR 时自动验证

---

### 2. **build-matrix.yml** (矩阵编译)

**触发条件**：
- ✅ 创建 tag（`v*` 格式）
- ✅ 手动触发

**功能**：
- 并行编译多个目标架构
  - `arm64`
  - `arm64e`
  - `Universal (arm64 + arm64e)`
- 自动创建 GitHub Release
- 上传所有二进制文件

**使用场景**：
- 发布新版本
- 生成多架构二进制包

---

### 3. **quick-build.yml** (快速开发编译)

**触发条件**：
- ✅ 推送到 `develop` 分支
- ✅ 创建 Pull Request

**功能**：
- 缓存 Theos（加速编译）
- 快速编译反馈
- 编译时间统计

**使用场景**：
- 快速迭代开发
- 集成到 develop 分支的自动验证

---

## 🚀 使用步骤

### 第一步：上传到 GitHub

```bash
# 添加远程仓库（替换 YOUR_USERNAME 和 YOUR_REPO）
git remote add origin https://github.com/YOUR_USERNAME/BlockWAUpdates.git

# 创建初始提交
git add .
git commit -m "Initial commit: BlockWAUpdates with GitHub Actions"

# 推送到主分支
git branch -M main
git push -u origin main
```

### 第二步：启用 GitHub Actions

1. 访问你的 GitHub 仓库页面
2. 点击 **Settings** → **Actions** → **General**
3. 确保 **Actions permissions** 设置为 **Allow all actions**

### 第三步：触发编译

#### 方法 A：推送代码（自动触发）
```bash
# 编辑代码后提交
git add .
git commit -m "Update tweak logic"
git push origin main
```

#### 方法 B：创建标签发布（自动编译并发布）
```bash
# 创建版本标签
git tag -a v1.0.2 -m "Release version 1.0.2"
git push origin v1.0.2
```

#### 方法 C：手动触发
1. 访问 GitHub 仓库 → **Actions** 选项卡
2. 选择工作流 → 点击 **Run workflow**
3. 选择分支和选项 → **Run workflow**

---

## 📊 工作流状态检查

### 查看编译状态

1. 点击仓库主页的 **Actions** 标签
2. 看到你的提交对应的工作流
3. 点击查看详细日志

### 工作流状态说明

| 状态 | 图标 | 说明 |
|------|------|------|
| 成功 | ✅ | 编译完成，可下载 |
| 进行中 | 🔄 | 正在编译，请耐心等待 |
| 失败 | ❌ | 编译失败，检查日志 |
| 取消 | ⏹️ | 工作流已取消 |

---

## 📥 下载编译产物

### 从 Artifacts 下载

1. 进入完成的工作流页面
2. 向下滚动到 **Artifacts** 部分
3. 点击下载：
   - `BlockWAUpdates-dylib` - dylib 文件
   - `BlockWAUpdates-deb` - deb 包文件

### 从 Releases 下载

1. 进入仓库首页
2. 点击右侧 **Releases**
3. 下载对应版本的文件

---

## 🔧 配置自定义编译选项

### 修改编译参数

编辑工作流文件中的编译命令：

```yaml
# build-tweak.yml 中的编译命令
make DEBUG=0 FINALPACKAGE=1 ARCHS="arm64 arm64e"
```

### 修改目标 iOS 版本

编辑 `Makefile` 或 `Makefile_SDK26`：

```makefile
# 改变最低 iOS 版本
TARGET = iphone:clang:latest:15.0
```

### 修改源文件

在工作流中切换使用的源文件：

```yaml
# 使用 Tweak_Modern.xm（推荐）或 Tweak.xm
# 编辑 Makefile 中的 BlockWAUpdates_FILES
```

---

## 🐛 故障排除

### 工作流失败

**检查清单**：

1. ✓ 检查 Makefile 语法
2. ✓ 验证源文件 (.xm) 存在
3. ✓ 检查 control 文件格式
4. ✓ 查看详细日志找错误信息

### 常见错误及解决

#### 错误：Theos not found

```
Error: THEOS environment variable not set
```

**原因**：工作流中 Theos 安装失败

**解决**：
```yaml
- name: Install Theos
  run: |
    git clone --depth=1 https://github.com/theos/theos.git ~/theos
    cd ~/theos
    git submodule update --init --recursive --depth=1
```

#### 错误：make: command not found

**原因**：macOS 环境未正确配置

**解决**：
```yaml
- name: Install tools
  run: |
    xcode-select --install
```

#### 错误：Logos 编译失败

**原因**：源文件 Logos 语法错误

**解决**：
1. 检查 `.xm` 文件的语法
2. 验证钩子定义
3. 查看详细日志找错误位置

---

## 📈 性能优化

### 使用缓存加速编译

目前 `quick-build.yml` 已配置缓存：

```yaml
- name: Cache Theos
  uses: actions/cache@v3
  with:
    path: ~/theos
    key: theos-${{ runner.os }}-${{ hashFiles('.github/workflows/quick-build.yml') }}
```

**优点**：
- ⚡ 首次编译后，后续编译快 50%+
- 💰 节省编译时间和 GitHub Actions 配额

### 并行编译多个架构

`build-matrix.yml` 使用矩阵策略：

```yaml
strategy:
  matrix:
    include:
      - name: "arm64"
      - name: "arm64e"
      - name: "Universal"
```

**优点**：
- ⚡ 三个编译任务并行进行
- 🎯 清晰的编译报告

---

## 🔐 安全注意事项

### Secrets 管理

如果需要上传到私有仓库或服务：

1. 访问 **Settings** → **Secrets and variables** → **Actions**
2. 点击 **New repository secret**
3. 添加密钥（如 SSH key、token 等）

### 工作流安全性

- ✅ 自动令牌 (GITHUB_TOKEN) 仅限当前仓库
- ✅ 工作流日志不包含密钥
- ✅ Artifacts 自动过期（30 天）

---

## 📋 最佳实践

### 提交前检查

```bash
# 本地构建测试
make clean
make package FINALPACKAGE=1

# 验证生成的文件
ls .theos/obj/*/BlockWAUpdates.dylib
ls .theos/packages/*.deb
```

### 版本管理

```bash
# 遵循语义化版本
git tag -a v1.0.0 -m "Release v1.0.0"  # 主版本更新
git tag -a v1.0.1 -m "Release v1.0.1"  # 补丁版本更新

git push origin --tags
```

### 分支策略

```
main (稳定版)
  ↑
  └── develop (开发版)
        ↑
        └── feature/* (功能分支)
```

- `feature/*` → `develop` （Pull Request）
- `develop` → `main` （发布版本）

---

## 📚 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Theos 官方文档](https://theos.dev/)
- [macOS-latest runners](https://github.com/actions/virtual-environments)
- [Logos 语法指南](https://theos.dev/docs/logos)

---

## 💡 高级用法

### 自定义构建脚本

如需更复杂的编译逻辑，可以创建 shell 脚本：

```bash
# scripts/build.sh
#!/bin/bash
set -e

export THEOS=~/theos
export PATH=$THEOS/bin:$PATH

# 编译步骤
make clean
make FINALPACKAGE=1 ARCHS="arm64 arm64e"

# 后处理
echo "Build completed!"
ls -lh .theos/obj/*/BlockWAUpdates.dylib
```

在工作流中调用：

```yaml
- name: Run build script
  run: bash scripts/build.sh
```

### 发送编译通知

```yaml
- name: Notify on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Build failed for BlockWAUpdates'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## ✅ 检查清单

在推送代码前，确保：

- [ ] 代码已在本地测试编译
- [ ] Makefile 语法正确
- [ ] 所有 `.xm` 文件已保存
- [ ] control 文件更新
- [ ] `.github/workflows/` 目录存在
- [ ] Git 提交信息清晰

---

## 📞 支持和帮助

如遇到问题：

1. 查看工作流的详细日志
2. 检查 [Theos 文档](https://theos.dev/)
3. 查阅 [GitHub Actions 文档](https://docs.github.com/en/actions)
4. 在项目 Issues 中提问

---

**祝你编译顺利！** 🎉
