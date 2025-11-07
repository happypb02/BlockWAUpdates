# BlockWAUpdates - WhatsApp 更新阻止插件

![version](https://img.shields.io/badge/version-1.0.1-blue)
![sdk](https://img.shields.io/badge/SDK-26-orange)
![ios](https://img.shields.io/badge/iOS-14.0+-green)
![license](https://img.shields.io/badge/license-MIT-red)

一个现代化的 iOS 越狱插件，用于阻止 WhatsApp 应用的版本过期提示和强制更新。

## ✨ 特性

- 🔒 完全阻止 WhatsApp 版本过期检查
- 📱 支持最新 iOS 18+ (SDK 26)
- ⚡ 轻量级高效 (~50KB)
- 🏗️ 现代 C++17 和最新 API
- 📝 完整的中文文档
- 🛠️ 自动化编译脚本
- 🎯 支持 arm64 和 arm64e 架构

## 📋 系统要求

| 要求 | 版本 |
|------|------|
| iOS 版本 | 14.0 或更高 |
| Xcode | 13.0+ (推荐 14.0+) |
| Theos | 最新版本 |
| MobileSubstrate | 0.9.5+ |

## 🚀 快速开始

### 1. 环境设置

```bash
# 设置 Theos 环境
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH
```

### 2. 编译

```bash
# 进入项目目录
cd /www/wwwroot/BlockWAUpdates

# 方法 1: 使用自动化脚本 (推荐)
./build.sh package

# 方法 2: 直接使用 Make
make package FINALPACKAGE=1
```

### 3. 安装

```bash
# 复制到设备
scp .theos/packages/*.deb root@<device-ip>:/tmp/

# SSH 进入并安装
ssh root@<device-ip>
dpkg -i /tmp/com.blockwaupdates.tweak_*.deb

# 重启 SpringBoard
killall SpringBoard
```

## 📂 项目结构

```
BlockWAUpdates/
├── Tweak_Modern.xm       # 现代版本源代码 (推荐)
├── Makefile_SDK26        # SDK 26 编译配置 (推荐)
├── build.sh              # 自动化编译脚本
├── control               # 包元数据
├── BUILD_INSTRUCTIONS.md # 详细编译说明
├── PROJECT_STRUCTURE.md  # 项目结构详解
└── README.md             # 本文件
```

## 🔧 编译命令

### 基础编译

```bash
# 仅编译 dylib
./build.sh build

# 编译并打包为 deb
./build.sh package

# 清理编译产物
./build.sh clean

# 重新编译
./build.sh rebuild
```

### 高级选项

```bash
# 编译调试版本
./build.sh debug package

# 显示编译信息
./build.sh info

# 仅编译 arm64 架构
make ARCHS="arm64" package
```

## 📖 文档

- **[BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)** - 详细的编译说明和故障排除
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - 项目结构和技术细节

## 🎯 功能说明

### 阻止的操作

| 操作 | 说明 |
|------|------|
| `isBuildExpired()` | 阻止版本过期检查 |
| `expireBuild()` | 阻止构建过期 |
| `presentHelperScreen()` | 阻止显示更新提示 |
| `wa_applicationDidEnterBackground()` | 后台事件处理 |

### 工作原理

插件通过 MobileSubstrate 框架钩接 WhatsApp 的 `WARootViewController` 类的关键方法，拦截版本检查逻辑，从而阻止"更新可用"或"版本已过期"的提示。

## 📊 编译信息

| 指标 | 值 |
|------|-----|
| SDK 版本 | 26 (iOS 18) |
| C++ 标准 | C++17 |
| 最小 iOS | 14.0 |
| 支持架构 | arm64, arm64e |
| dylib 大小 | ~50KB |
| 编译时间 | 10-20 秒 |
| 内存管理 | ARC |

## 🔄 更新历史

### v1.0.1 (2025-11-07)
- ✅ 升级至 SDK 26
- ✅ 现代化源代码
- ✅ 自动化编译脚本
- ✅ 完整的中文文档
- ✅ C++17 支持

### v1.0.0
- 初始版本
- 基础功能实现

## ⚠️ 注意事项

1. **需要越狱设备** - 此插件仅在越狱 iOS 设备上工作
2. **设备兼容性** - 需要 iOS 14.0 或更高版本
3. **风险声明** - 使用本插件造成的任何问题由使用者自负
4. **WhatsApp 版本** - 仅支持特定版本的 WhatsApp (通常是较旧版本)

## 🐛 常见问题

### Q: 编译失败提示 "Theos not found"？
**A**: 确保 THEOS 环境变量已正确设置：
```bash
export THEOS=~/theos
```

### Q: 可以在 macOS 上编译吗？
**A**: 可以！这是最推荐的编译平台。

### Q: 支持哪些 iPhone 型号？
**A**: iOS 14.0+ 的所有 iPhone，包括：
- iPhone XS / XR 及更新型号
- 采用 arm64e 架构的所有设备

### Q: 如何卸载插件？
**A**:
```bash
dpkg -r com.blockwaupdates.tweak
killall SpringBoard
```

## 🛠️ 开发和自定义

### 修改源代码

编辑 `Tweak_Modern.xm` 添加新的钩子或逻辑。

### 自定义编译

编辑 `Makefile_SDK26` 修改编译参数：

```makefile
# 改变最低 iOS 版本
TARGET = iphone:clang:latest:15.0

# 添加自定义编译标志
BlockWAUpdates_CFLAGS = -fobjc-arc -std=c++17 -DCUSTOM_FLAG
```

## 📦 分发

### 创建自己的 Cydia 仓库

1. 编译 deb 包
2. 上传到 Web 服务器
3. 创建 Packages 索引
4. 在 Cydia 中添加仓库源

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📜 许可证

MIT License - 详见 LICENSE 文件

```
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 📞 技术支持

### 遇到问题？

1. 检查 [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) 中的故障排除部分
2. 查看 [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) 了解技术细节
3. 查证系统要求是否满足

### 相关资源

- [Theos 官方文档](https://theos.dev/)
- [Logos 语法指南](https://theos.dev/docs/logos)
- [iOS SDK 文档](https://developer.apple.com/documentation)

## 🎓 学习资源

本项目可作为学习以下技术的参考：

- iOS 越狱开发
- Theos 框架使用
- Logos 方法钩接
- MobileSubstrate 编程
- Objective-C/C++ 混合编程
- 现代 iOS 开发工具链

## 📝 更新日期

最后更新: 2025-11-07

---

**免责声明**: 本项目仅供学习和研究使用。用户对使用本代码造成的任何后果负全部责任。请遵守相关法律法规。
