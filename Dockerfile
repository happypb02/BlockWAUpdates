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
