#!/bin/bash
set -e

echo "🚀 准备启动 ComfyUI..."

# ---- 确保环境已初始化 ----
source /workspace/assets/setup_env.sh

# ---- 进入 ComfyUI 并启动 ----
cd /workspace/ComfyUI
python main.py --listen 0.0.0.0 --port 8188
