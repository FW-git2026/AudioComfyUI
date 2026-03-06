#!/bin/bash

# 进入你的项目根目录（根据你的实际路径调整，通常是 /workspace 或 /workspace/ComfyUI）
cd /workspace/ComfyUI

find /workspace/ComfyUI/custom_nodes -mindepth 2 -type d -name ".git" -exec rm -rf {} +

# （可选）检查当前 Git 状态，查看将要提交的文件
git status

# （精准推荐）只添加你明确要提交的文件，比如：
# git add setup_env.sh
# git add .gitignore
# 或者添加所有（如果你确定）
git add .

# 提交更改，写清晰的 commit 信息
git commit -m "同步更新"

# 检查是否关联了远程仓库
git remote -v

# 如果你尚未关联远程仓库，先添加（只需一次）：
# git remote add origin https://github.com/你的用户名/你的仓库.git

# 推送到远程仓库（如 main 分支）
git push origin main
