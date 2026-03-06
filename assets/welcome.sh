#!/bin/bash
set -e

echo "=============================================="
echo "🤖 ComfyUI 智能启动助手"
echo "=============================================="

read -p "🔍 是否要启动 ComfyUI？请输入 y/Y 继续，其他键将退出: " user_input

if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
  echo "❌ 用户取消启动，退出脚本。"
  exit 0
fi

echo "✅ 用户确认启动，继续执行..."

# ---- 调用环境初始化脚本 ----
source /workspace/assets/setup_env.sh

# ---- 调用真正的启动脚本 ----
START_SCRIPT="/workspace/assets/start.sh"
if [ -f "$START_SCRIPT" ]; then
    echo "🚀 调用启动脚本：$START_SCRIPT"
    chmod +x "$START_SCRIPT"
    bash "$START_SCRIPT"
else
    echo "❌ 启动脚本不存在：$START_SCRIPT"
    exit 1
fi
