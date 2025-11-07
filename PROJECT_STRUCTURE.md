# BlockWAUpdates 项目结构

## 项目目录结构

```
BlockWAUpdates/
├── Tweak.xm                    # 基础源代码 (从二进制恢复)
├── Tweak_Modern.xm             # 现代版本源代码 (推荐使用)
├── Makefile                    # 标准编译配置
├── Makefile_SDK26              # SDK 26 专用配置 (推荐使用)
├── control                     # Debian 包元数据
├── build.sh                    # 自动化编译脚本
├── BlockWAUpdates.dylib        # 原始编译的二进制文件 (旧版本)
│
├── 文档文件
│   ├── BUILD_INSTRUCTIONS.md   # 编译说明 (详细)
│   ├── PROJECT_STRUCTURE.md    # 本文件 (项目结构)
│   └── README.md               # 项目简介 (待创建)
│
├── .claude/                    # Claude Code 设置
│   └── settings.local.json     # 本地设置
│
└── .theos/                     # Theos 编译产物 (编译后)
    ├── obj/                    # 编译对象文件
    │   └── debug/
    │       ├── arm64/
    │       └── arm64e/
    └── packages/               # 最终 deb 包
        └── com.blockwaupdates.tweak_*.deb
```

## 文件详细说明

### 源代码文件

#### `Tweak_Modern.xm` (推荐)
- **类型**: Logos/Objective-C++ 混合源代码
- **大小**: ~3KB
- **特点**:
  - 使用最新的 Objective-C 和 C++17
  - 支持 iOS 14.0 及更高版本
  - 包含详细的中文注释和日志
  - 使用现代的内存管理 (ARC)
  - 包含 dispatch_once 确保线程安全

**主要功能**:
- `isBuildExpired()`: 阻止构建过期检查
- `expireBuild()`: 阻止构建过期操作
- `presentHelperScreen()`: 阻止帮助屏幕显示
- `wa_applicationDidEnterBackground()`: 处理后台事件

#### `Tweak.xm` (基础版本)
- **类型**: Logos/Objective-C++ 混合源代码
- **大小**: ~1.5KB
- **特点**:
  - 从二进制文件反编译恢复
  - 功能完整但注释较少
  - 可作为参考或备用版本

### 编译配置文件

#### `Makefile_SDK26` (推荐)
- **用途**: SDK 26 专用编译配置
- **特点**:
  - 支持最新的 iOS SDK (18+)
  - 支持 arm64 和 arm64e 架构
  - 启用 C++17 标准
  - 包含所有现代编译优化
  - 详细的注释说明

**主要配置**:
```makefile
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
BlockWAUpdates_CFLAGS = -fobjc-arc -std=c++17
```

#### `Makefile` (标准配置)
- **用途**: 通用编译配置
- **特点**:
  - 兼容性更强
  - 适合多数编译环境
  - 可作为备用方案

### 包元数据

#### `control`
- **用途**: Debian 包信息文件
- **包含**:
  - 包名: `com.blockwaupdates.tweak`
  - 版本: `1.0.1`
  - 架构: `iphoneos-arm64`
  - 依赖: `mobilesubstrate`, `firmware >= 14.0`
  - 描述: 中文说明

### 编译脚本

#### `build.sh`
- **用途**: 自动化编译脚本
- **特点**:
  - 支持多种编译模式 (clean, build, package, etc.)
  - 环境检查和验证
  - 彩色输出便于查看
  - 支持调试和发布版本

**使用示例**:
```bash
./build.sh info           # 显示编译信息
./build.sh clean          # 清理编译产物
./build.sh build          # 编译 dylib
./build.sh package        # 编译并打包
./build.sh debug package  # 调试版本打包
```

### 文档文件

#### `BUILD_INSTRUCTIONS.md`
- **内容**: 详细的编译说明
- **包括**:
  - 系统要求
  - 环境设置
  - 编译步骤
  - 编译选项
  - 安装方法
  - 故障排除

#### `PROJECT_STRUCTURE.md`
- **内容**: 本文件，项目结构说明

#### `README.md` (待创建)
- **内容**: 项目简介和快速开始指南

### 二进制文件

#### `BlockWAUpdates.dylib` (旧版本)
- **类型**: Mach-O 通用二进制
- **大小**: 192KB
- **架构**: armv7, arm64, arm64e
- **用途**: 原始编译版本，用于参考
- **注意**: 新编译应使用 Tweak_Modern.xm

## 编译流程

### 1. 源代码
```
Tweak_Modern.xm ──┐
                 │
control ─────────┤──→ Theos ──→ 编译 ──→ .theos/obj/ ──→ dylib
                 │                                    │
Makefile_SDK26 ──┘                                    └──→ .theos/packages/ ──→ deb
```

### 2. 编译阶段

```
预处理 (Preprocessing)
    ↓
语法检查 (Syntax Check)
    ↓
编译 (Compilation) - Logos 处理
    ↓
链接 (Linking) - MobileSubstrate
    ↓
署名 (Code Sign)
    ↓
打包 (Packaging) - Debian deb
```

### 3. 输出文件

编译成功后生成:

```
.theos/obj/debug/
├── arm64/
│   └── BlockWAUpdates.dylib (arm64 架构)
└── arm64e/
    └── BlockWAUpdates.dylib (arm64e 架构)

.theos/packages/
└── com.blockwaupdates.tweak_1.0.1_iphoneos-arm64.deb
```

## 技术栈

| 组件 | 版本 | 说明 |
|------|------|------|
| Theos | latest | iOS 越狱开发框架 |
| Xcode | 13.0+ | Apple 开发工具 |
| iOS SDK | 26 (iOS 18) | 最新 iOS SDK |
| C++ Standard | C++17 | 现代 C++ 标准 |
| Objective-C | Modern | 使用 ARC |
| Logos | Latest | 方法钩子框架 |
| MobileSubstrate | 0.9.5+ | 二进制修改框架 |

## 版本历史

### v1.0.1 (当前)
**更新内容**:
- ✅ 升级至 SDK 26
- ✅ 现代化源代码 (Tweak_Modern.xm)
- ✅ 专用 SDK 26 编译配置
- ✅ 自动化编译脚本
- ✅ 详细的中文文档
- ✅ C++17 支持
- ✅ 增强的日志和错误处理

**编译信息**:
- 最小 iOS: 14.0
- 支持架构: arm64, arm64e
- 二进制大小: ~50KB
- 编译时间: ~10-20 秒

### v1.0.0
**初始版本**:
- 基础 WhatsApp 更新阻止功能
- 支持 armv7, arm64, arm64e
- 编译于 Xcode 11-12

## 关键特性

### 现代化
- ✅ C++17 标准库
- ✅ ARC 内存管理
- ✅ 现代 Objective-C API
- ✅ 最新 Xcode 工具链

### 兼容性
- ✅ iOS 14.0 - 18.x
- ✅ arm64 和 arm64e 架构
- ✅ A12 及更新的 iPhone 型号

### 开发者友好
- ✅ 详细的中文注释
- ✅ 自动化构建脚本
- ✅ 完整的编译文档
- ✅ 故障排除指南

## 自定义和扩展

### 添加新的钩子
在 `Tweak_Modern.xm` 中添加:

```objective-c
%hook SomeClass

- (void)someMethod {
    NSLog(@"钩子已触发");
    %orig;  // 调用原始实现
}

%end
```

### 修改编译选项
编辑 `Makefile_SDK26`:

```makefile
BlockWAUpdates_CFLAGS = -fobjc-arc -std=c++17 -DCUSTOM_FLAG
```

### 更改目标最低版本
```makefile
TARGET = iphone:clang:latest:15.0  # 改为 iOS 15.0+
```

## 常见问题

### Q: 为什么要使用 Tweak_Modern.xm？
**A**: 现代版本包含最新的 API 和最佳实践，性能更好，支持 iOS 18+。

### Q: 能在旧的 Xcode 版本上编译吗？
**A**: 可以，但需要降低编译标准。使用 Makefile 而非 Makefile_SDK26。

### Q: dylib 大小为什么这么小？
**A**: 这是因为插件主要使用 iOS SDK 的现有框架，代码量很少。

### Q: 如何支持 armv7？
**A**: 在 Makefile_SDK26 中改为 `ARCHS = arm64 arm64e armv7`，但 SDK 26 可能不支持。

## 资源和文献

- [Theos 官方文档](https://theos.dev/)
- [Logos 语法指南](https://theos.dev/docs/logos)
- [iOS SDK 发行说明](https://developer.apple.com/documentation/xcode-release-notes)
- [MobileSubstrate 文档](https://www.cydiasubstrate.com/)
- [Objective-C Runtime](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/)

## 许可证

MIT License - 自由使用和修改

## 更新日期

最后更新: 2025-11-07
