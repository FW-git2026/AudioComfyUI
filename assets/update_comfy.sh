#!/bin/bash
set -e

# =============================================
# ComfyUI 一键更新脚本（标准安全版）
#
# 功能包括：
# - 更新 ComfyUI 主程序（git pull origin/main）
# - 更新 ComfyUI-Manager（git pull origin/main）
# - 更新 Python 依赖（requirements.txt）
# - 支持 uv pip 或 pip（自动降级）
# - 冲突提示、重启指引、详细日志
# =============================================

echo "🚀 开始更新 ComfyUI 及相关组件..."

# --------------------------
# 1. 更新 ComfyUI 主程序
# --------------------------

echo "📂 进入 ComfyUI 源码目录..."
cd /workspace/ComfyUI || { echo "❌ 无法进入 /workspace/ComfyUI 目录！请确认路径是否正确。"; exit 1; }

echo "🔗 检查 Git 是否可用..."
git --version &> /dev/null || { echo "❌ Git 未安装或不可用！请确保已安装 Git。"; exit 1; }

echo "✅ Git 可用，准备更新..."
echo "📥 拉取 ComfyUI 最新代码 (origin/main)..."

# 尝试拉取主线代码
if git pull origin main; then
  echo "✅ ComfyUI 代码更新成功！"
else
  echo "⚠️  ComfyUI 拉取代码时出现问题，可能遇到本地修改冲突或网络错误！"
  echo "   请进入 /workspace/ComfyUI 目录运行 'git status' 查看冲突，解决后重新拉取。"
fi

# --------------------------
# 2. 更新 Python 依赖
# --------------------------

echo ""
echo "📥 更新 Python 依赖..."

# 检测是否存在 uv（高性能 pip），否则使用 pip
if command -v uv &> /dev/null; then
  echo "🔧 使用 'uv pip' 安装/更新依赖..."
  if uv pip install -U -r /workspace/ComfyUI/requirements.txt; then
    echo "✅ 依赖 (uv) 更新完成！"
  else
    echo "⚠️  uv pip 安装依赖时出现问题，但可能部分成功。"
  fi
else
  echo "🔧 使用标准 'pip' 安装依赖..."
  if pip install -U -r /workspace/ComfyUI/requirements.txt; then
    echo "✅ 依赖 (pip) 更新完成！"
  else
    echo "⚠️  pip 安装依赖时出现问题，但可能部分成功。"
  fi
fi

# --------------------------
# 3. 更新 ComfyUI-Manager（自定义节点）
# --------------------------

echo ""
echo "📂 进入 ComfyUI-Manager 目录..."
CUSTOM_MANAGER_DIR="/workspace/ComfyUI/custom_nodes/ComfyUI-Manager"
cd "$CUSTOM_MANAGER_DIR" || { echo "❌ 无法进入 ComfyUI-Manager 目录：$CUSTOM_MANAGER_DIR"; exit 1; }

echo "🔗 检查 ComfyUI-Manager 的 Git 状态..."
if [ -d ".git" ]; then
  echo "✅ ComfyUI-Manager 存在 Git 目录，准备更新..."
  echo "📥 拉取 ComfyUI-Manager 最新代码 (origin/main)..."
  if git pull origin main; then
    echo "✅ ComfyUI-Manager 更新成功！"
  else
    echo "⚠️  ComfyUI-Manager 拉取时遇到问题，可能本地有修改或冲突，请检查后重试。"
  fi
else
  echo "⚠️  ComfyUI-Manager 目录下没有发现 Git 管理 (.git 目录不存在)，跳过更新。"
  echo "   你可能手动安装了 ComfyUI-Manager，如需更新，请自行拉取。"
fi

# --------------------------
# 4. 更新 ComfyUI 生态相关包（可选，用 uv/pip）
# --------------------------

echo ""
echo "📦 更新 ComfyUI 生态工具包..."

PIPS_TO_INSTALL=(
  "comfy-cli"
  "comfyui-frontend-package"
  "comfyui-workflow-templates"
  "comfyui-embedded-docs"
)

for package in "${PIPS_TO_INSTALL[@]}"; do
  echo "🔧 安装/更新: $package"
  if command -v uv &> /dev/null; then
    uv pip install -U "$package" || echo "⚠️  uv pip 安装 $package 时出现问题，但可能已存在。"
  else
    pip install -U "$package" || echo "⚠️  pip 安装 $package 时出现问题，但可能已存在。"
  fi
done

echo "✅ ComfyUI 生态工具更新完成（或已是最新）！"

# --------------------------
# 5. 更新完成，提示用户操作
# --------------------------

echo ""
echo "🛠️  更新完成！"
echo ""
echo "📌 请根据你的启动方式选择后续操作："
echo "   - 如果你使用的是 start.sh 启动脚本，请重新运行它："
echo "         bash /workspace/assets/start.sh"
echo "   - 如果你使用的是平台自动启动（如 CNB / Docker），请重启容器或服务"
echo "   - 如果你遇到代码冲突（比如自己改过 ComfyUI），请进入对应目录运行："
echo "         git status"
echo "         git diff"
echo "         手动解决冲突后，再尝试 git pull"
echo ""
echo "✨ 恢复正常使用吧！"
