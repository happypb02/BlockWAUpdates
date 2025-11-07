FINALPACKAGE = 1
DEBUG = 0

# 使用最新的 Theos 和 SDK 配置
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

# 导入 Theos 框架
include $(THEOS)/makefiles/common.mk

# 声明 tweaks
TWEAK_NAME = iospredty

# 源文件
iospredty_FILES = Tweak.xm
iospredty_FRAMEWORKS = Foundation UIKit

# 编译器标志 - 使用现代 SDK
iospredty_CFLAGS = -fobjc-arc -std=c++17
iospredty_LDFLAGS = -lsubstrate

# 导入规则
include $(THEOS_MAKE_PATH)/tweak.mk

# 导入打包规则
include $(THEOS_MAKE_PATH)/package.mk
