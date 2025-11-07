#!/bin/bash
# BlockWAUpdates 快速编译脚本
# 使用 SDK 26 编译

set -e  # 遇到错误立即退出

# 颜色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 检查环境
check_env() {
    print_info "检查编译环境..."

    # 检查 Theos
    if [ -z "$THEOS" ]; then
        print_error "THEOS 环境变量未设置"
        echo "请运行: export THEOS=~/theos"
        exit 1
    fi

    if [ ! -d "$THEOS" ]; then
        print_error "Theos 目录不存在: $THEOS"
        exit 1
    fi

    print_success "Theos 路径: $THEOS"

    # 检查 Xcode
    if ! command -v xcode-select &> /dev/null; then
        print_error "Xcode 未安装"
        exit 1
    fi

    local xcode_path=$(xcode-select -p)
    print_success "Xcode 路径: $xcode_path"

    # 检查 Makefile
    if [ ! -f "Makefile_SDK26" ]; then
        print_warning "找不到 Makefile_SDK26，使用默认 Makefile"
        return 0
    fi

    print_success "找到 Makefile_SDK26"
}

# 显示帮助信息
show_help() {
    cat << EOF
BlockWAUpdates 编译脚本

用法: $0 [选项]

选项:
    clean       清理编译产物
    build       编译 dylib (不打包)
    package     编译并打包为 deb
    rebuild     清理后重新编译
    debug       编译调试版本
    release     编译发布版本 (默认)
    info        显示编译信息
    help        显示此帮助信息

示例:
    $0 build          # 编译 dylib
    $0 package        # 编译并打包
    $0 clean rebuild  # 清理后重新编译
    $0 debug package  # 编译调试版本并打包
EOF
}

# 显示编译信息
show_info() {
    print_info "编译信息:"
    echo "  源文件: Tweak_Modern.xm"
    echo "  目标: iPhone (iOS 14.0+)"
    echo "  架构: arm64, arm64e"
    echo "  Theos: $THEOS"
    echo ""
}

# 清理
do_clean() {
    print_info "清理编译产物..."
    make clean 2>/dev/null || true
    rm -rf .theos 2>/dev/null || true
    print_success "清理完成"
}

# 编译
do_build() {
    print_info "开始编译..."

    # 选择 Makefile
    local makefile="Makefile"
    if [ -f "Makefile_SDK26" ]; then
        print_info "使用 SDK 26 配置"
        makefile="Makefile_SDK26"
    fi

    # 编译
    if [ "$DEBUG_MODE" = "1" ]; then
        print_info "编译调试版本..."
        make -f "$makefile" DEBUG=1
    else
        print_info "编译发布版本..."
        make -f "$makefile" FINALPACKAGE=1
    fi

    if [ $? -eq 0 ]; then
        print_success "编译成功"
        return 0
    else
        print_error "编译失败"
        exit 1
    fi
}

# 打包
do_package() {
    print_info "打包为 deb..."

    local makefile="Makefile"
    if [ -f "Makefile_SDK26" ]; then
        makefile="Makefile_SDK26"
    fi

    if [ "$DEBUG_MODE" = "1" ]; then
        make -f "$makefile" package DEBUG=1
    else
        make -f "$makefile" package FINALPACKAGE=1
    fi

    if [ $? -eq 0 ]; then
        print_success "打包成功"

        # 显示生成的文件
        echo ""
        print_info "生成的文件:"
        find .theos -name "*.deb" 2>/dev/null | while read file; do
            echo "  $file"
        done
        return 0
    else
        print_error "打包失败"
        exit 1
    fi
}

# 主程序
main() {
    cd "$(dirname "$0")"

    # 解析命令行参数
    DEBUG_MODE=0
    ACTIONS=()

    for arg in "$@"; do
        case "$arg" in
            debug)
                DEBUG_MODE=1
                ;;
            release)
                DEBUG_MODE=0
                ;;
            clean|build|package|rebuild|info|help)
                ACTIONS+=("$arg")
                ;;
            *)
                print_error "未知选项: $arg"
                show_help
                exit 1
                ;;
        esac
    done

    # 如果没有指定操作，显示帮助
    if [ ${#ACTIONS[@]} -eq 0 ]; then
        show_help
        exit 0
    fi

    # 检查环境
    check_env

    # 执行操作
    for action in "${ACTIONS[@]}"; do
        case "$action" in
            help)
                show_help
                ;;
            info)
                show_info
                ;;
            clean)
                do_clean
                ;;
            build)
                do_build
                ;;
            package)
                do_build
                do_package
                ;;
            rebuild)
                do_clean
                do_build
                ;;
            *)
                print_error "未知操作: $action"
                exit 1
                ;;
        esac
    done

    print_success "所有操作完成"
}

# 执行主程序
main "$@"
