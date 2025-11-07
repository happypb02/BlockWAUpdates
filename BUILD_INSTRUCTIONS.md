# BlockWAUpdates 编译说明 (SDK 26)

## 项目概述

BlockWAUpdates 是一个 iOS 越狱插件 (Tweak)，用于阻止 WhatsApp 应用的更新提示。该项目已更新为使用最新的 iOS SDK 和现代 C++ API。

## 文件说明

### 核心源代码
- **Tweak_Modern.xm** - 现代版本源代码（推荐使用）
  - 使用最新的 Objective-C 和 C++17 语法
  - 支持 iOS 14.0+
  - 包含详细注释和日志

- **Tweak.xm** - 基础版本源代码
  - 从二进制文件反编译恢复
  - 功能完整但注释较少

### 构建配置文件
- **Makefile_SDK26** - SDK 26 专用编译配置（推荐使用）
  - 支持 arm64 和 arm64e 架构
  - 使用最新的 Xcode 工具链
  - 包含完整的编译优化标志

- **Makefile** - 标准编译配置
  - 兼容性更强
  - 适合基础编译

### 包元数据
- **control** - Debian 包控制文件
  - 包含包信息和依赖项
  - 用于 Cydia/Sileo 仓库

## 系统要求

1. **Theos** - iOS 越狱开发框架
   ```bash
   git clone --recursive https://github.com/theos/theos.git ~/theos
   ```

2. **Xcode** - Apple 开发工具
   - 最低版本: 13.0+
   - 推荐: 14.0+ (包含 SDK 26)

3. **iOS SDK 26** (可选，但推荐)
   - 包含在最新 Xcode 中
   - 支持 iOS 18+ API

4. **MobileSubstrate**
   - 二进制修改框架
   - 必须安装在目标 iOS 设备

## 编译步骤

### 1. 环境设置

```bash
# 设置 Theos 环境变量
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH

# 验证 Xcode 路径
xcode-select --print-path
```

### 2. 使用 SDK 26 编译

**方案 A: 使用 SDK 26 专用配置（推荐）**

```bash
cd /www/wwwroot/BlockWAUpdates

# 重命名 Makefile
mv Makefile Makefile.backup
mv Makefile_SDK26 Makefile

# 编译
make clean
make

# 打包
make package FINALPACKAGE=1
```

**方案 B: 使用标准 Makefile**

```bash
cd /www/wwwroot/BlockWAUpdates

# 编译
make clean
make package FINALPACKAGE=1
```

### 3. 编译输出

编译成功后，生成的文件位置：

```
.theos/
├── obj/
│   └── debug/
│       ├── arm64/
│       │   └── BlockWAUpdates.dylib
│       └── arm64e/
│           └── BlockWAUpdates.dylib
└── packages/
    └── com.blockwaupdates.tweak_1.0.1_iphoneos-arm64.deb
```

## 编译选项

### 启用调试信息

```bash
make DEBUG=1 package
```

### 指定目标架构

```bash
make ARCHS="arm64" package   # 仅编译 64-bit
make ARCHS="arm64e" package  # 仅编译 arm64e
```

### 自定义 SDK 版本

```bash
make TARGET="iphone:clang:14.4:14.0" package
```

## 安装到设备

### 方案 1: 通过 SSH (推荐)

```bash
# 先编译
make package

# 复制到设备
scp .theos/packages/*.deb root@<device-ip>:/tmp/

# SSH 进入设备
ssh root@<device-ip>

# 在设备上安装
dpkg -i /tmp/com.blockwaupdates.tweak_*.deb
```

### 方案 2: 通过 Cydia/Sileo

1. 编译 deb 包
2. 上传到私有仓库
3. 在 Cydia/Sileo 中添加仓库
4. 安装插件

## 故障排除

### 编译错误: "Theos not found"

```bash
# 检查 THEOS 环境变量
echo $THEOS

# 如果为空，设置路径
export THEOS=~/theos
```

### 编译错误: "SDK 26 not found"

```bash
# 更新 Xcode 至最新版本
xcode-select --install

# 或指定较低的 SDK 版本
make TARGET="iphone:clang:13.0:14.0" package
```

### 链接错误: "libsubstrate not found"

```bash
# 确保 MobileSubstrate 开发文件已安装
# 在越狱设备上: apt-get install mobilesubstrate

# 或手动指定路径
make BlockWAUpdates_LDFLAGS="-L/path/to/substrate -lsubstrate"
```

## 代码更新说明

### 从旧版本升级

如果从旧的二进制版本升级，新版本包括：

1. **现代 C++ 标准**: 使用 C++17 而非旧的 C++11
2. **改进的错误处理**: 更好的日志记录和错误信息
3. **增强的兼容性**: 支持 iOS 18+ API
4. **优化的性能**: 编译时优化和运行时性能提升

### API 变更

- 使用 `UIDevice` 代替已弃用的 `UIScreen`
- 使用 `dispatch_once` 确保线程安全初始化
- 现代的内存管理 (ARC)

## 签名和证书

编译后的 dylib 需要签名才能在真实设备上运行：

```bash
# 使用 adhoc 签名
codesign -s - BlockWAUpdates.dylib

# 或使用开发证书
codesign -s "iPhone Developer" BlockWAUpdates.dylib
```

## 性能指标

编译配置优化：

| 指标 | 值 |
|------|-----|
| 最小 iOS 版本 | 14.0 |
| 支持架构 | arm64, arm64e |
| 代码优化级别 | -O2 |
| 调试符号 | 默认包含 |
| dylib 大小 | ~50KB |

## 许可证

BlockWAUpdates 使用标准 MIT 许可证。

## 更新历史

### v1.0.1 (2025-11-07)
- 更新至 SDK 26
- 升级至 C++17
- 改进文档和注释
- 优化编译配置

### v1.0.0
- 初始二进制版本
- 基础 WhatsApp 更新阻止功能

## 联系方式

遇到问题？请检查：

1. Theos 安装和配置
2. Xcode 版本和 SDK
3. MobileSubstrate 开发文件
4. 设备越狱状态

## 相关资源

- [Theos 官方文档](https://theos.dev/)
- [Logos 语法指南](https://theos.dev/docs/logos)
- [iOS SDK 发行说明](https://developer.apple.com/documentation)
