#!/bin/bash
set -e

echo "🔧 正在初始化 ComfyUI 环境..."

# =============================================
# 1. 检查并安装 uv（Astral 的高性能 pip 工具）
# =============================================

echo "🔍 检查是否已安装 'uv'（高性能 pip 工具）..."

if command -v uv &> /dev/null; then
  echo "✅ 'uv' 已安装，版本：$(uv --version 2>/dev/null || echo '未知版本')"
else
  echo "⚠️  'uv' 未安装，尝试通过 pip 安装..."

  if pip install uv; then
    echo "✅ 'uv' 安装成功！"
  else
    echo "❌ 'uv' 安装失败！将降级使用标准 'pip' 进行依赖安装。"
  fi
fi

# 如果 uv 不可用，提示用户后续可能降级到 pip
if ! command -v uv &> /dev/null; then
  echo "⚠️  警告：'uv' 不可用，后续依赖安装将使用标准 'pip'（速度可能较慢）。"
  echo "   如需使用 'uv'，请手动运行：pip install uv"
fi

# =============================================
# 2. 安装 Git（如未安装）
# =============================================

if ! command -v git &> /dev/null; then
    echo "📦 安装 Git..."
    apt-get update && apt-get install -y git
else
    echo "✅ Git 已安装，跳过。"
fi

# =============================================
# 3. 安装 aria2c（如未安装）
# =============================================

if ! command -v aria2c &> /dev/null; then
    echo "📦 安装 aria2c..."
    apt-get update && apt-get install -y aria2
else
    echo "✅ aria2c 已安装，跳过。"
fi

# =============================================
# 4. 安装 Python 包：modelscope（如未安装）
# =============================================

if ! python3 -c "import modelscope" &> /dev/null; then
    echo "📦 安装 Python 包：modelscope..."
    pip install modelscope
else
    echo "✅ modelscope 已安装，跳过。"
fi

# =============================================
# 5. 检查并克隆 ComfyUI（如未克隆）
# =============================================

COMFYUI_DIR="/workspace/ComfyUI"
if [ ! -d "$COMFYUI_DIR" ]; then
    echo "📥 克隆 ComfyUI..."
    git clone https://github.com/Comfy-Org/ComfyUI.git "$COMFYUI_DIR"
else
    echo "✅ ComfyUI 已克隆，跳过。"
fi

# =============================================
# 6. 检查并安装 ComfyUI 依赖（通过 flag 避免重复）
# =============================================

REQUIREMENTS_FLAG="$COMFYUI_DIR/requirements-installed.flag"
if [ ! -f "$REQUIREMENTS_FLAG" ]; then
    echo "📦 安装 ComfyUI Python 依赖..."
    pip install -r "$COMFYUI_DIR/requirements.txt"
    touch "$REQUIREMENTS_FLAG"
else
    echo "✅ ComfyUI 依赖已安装，跳过。"
fi

echo "✅ 环境初始化完成！"
