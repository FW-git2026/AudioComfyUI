#!/bin/bash
set -e

echo "🔧 正在初始化 ComfyUI 环境..."

# --- 安装 Git ---
if ! command -v git &> /dev/null; then
    echo "📦 安装 Git..."
    apt-get update && apt-get install -y git
else
    echo "✅ Git 已安装，跳过。"
fi

# --- 安装 aria2c ---
if ! command -v aria2c &> /dev/null; then
    echo "📦 安装 aria2c..."
    apt-get update && apt-get install -y aria2
else
    echo "✅ aria2c 已安装，跳过。"
fi

# --- 安装 modelscope ---
if ! python3 -c "import modelscope" &> /dev/null; then
    echo "📦 安装 Python 包：modelscope..."
    pip install modelscope
else
    echo "✅ modelscope 已安装，跳过。"
fi

# --- 克隆 ComfyUI ---
COMFYUI_DIR="/workspace/ComfyUI"
if [ ! -d "$COMFYUI_DIR" ]; then
    echo "📥 克隆 ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI.git "$COMFYUI_DIR"
else
    echo "✅ ComfyUI 已克隆，跳过。"
fi

# --- 安装 ComfyUI 依赖 ---
REQUIREMENTS_FLAG="$COMFYUI_DIR/requirements-installed.flag"
if [ ! -f "$REQUIREMENTS_FLAG" ]; then
    echo "📦 安装 ComfyUI 依赖..."
    pip install -r "$COMFYUI_DIR/requirements.txt"
    touch "$REQUIREMENTS_FLAG"
else
    echo "✅ ComfyUI 依赖已安装，跳过。"
fi

echo "✅ 环境初始化完成！"
