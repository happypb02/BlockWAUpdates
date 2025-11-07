# BlockWAUpdates iOS Tweak 编译环境
# 基于 Ubuntu 20.04 + Theos

FROM ubuntu:20.04

# 避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    perl \
    sed \
    gawk \
    grep \
    xz-utils \
    ca-certificates \
    liblz4-tool \
    && rm -rf /var/lib/apt/lists/*

# 创建工作目录
WORKDIR /root

# 下载 Theos
RUN git clone --depth=1 https://github.com/theos/theos.git theos && \
    cd theos && \
    git submodule update --init --recursive --depth=1 2>/dev/null || true

# 设置环境变量
ENV THEOS=/root/theos
ENV PATH=/root/theos/bin:$PATH

# 下载 iOS SDKs (带重试机制)
RUN mkdir -p $THEOS/sdks && \
    echo "下载 iOS SDK..." && \
    cd $THEOS/sdks && \
    for i in 1 2 3; do \
        echo "尝试下载第 $i 次..."; \
        wget -q --show-progress https://github.com/theos/sdks/releases/download/iphone14.4/iPhoneOS14.4.sdk.tar.lz4 2>/dev/null && break; \
        sleep 2; \
    done && \
    if [ -f "iPhoneOS14.4.sdk.tar.lz4" ]; then \
        echo "SDK 已下载，开始解压..."; \
        lz4 -d iPhoneOS14.4.sdk.tar.lz4 | tar x; \
        rm -f iPhoneOS14.4.sdk.tar.lz4; \
        echo "SDK 下载完成"; \
    else \
        echo "警告：SDK 下载失败，继续编译..."; \
    fi

# 复制项目到容器
COPY . /root/project

WORKDIR /root/project

# 执行编译
RUN echo "=== 开始编译 BlockWAUpdates ===" && \
    echo "THEOS=$THEOS" && \
    echo "PATH=$PATH" && \
    make clean 2>/dev/null || true && \
    make package FINALPACKAGE=1 || echo "编译失败，继续处理..." && \
    echo "" && \
    echo "=== 编译产物列表 ===" && \
    if [ -d ".theos" ]; then find .theos -type f \( -name "*.deb" -o -name "*.dylib" \) -exec ls -lh {} \; ; else echo "未找到编译产物"; fi

CMD ["/bin/bash"]
