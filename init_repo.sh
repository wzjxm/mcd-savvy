#!/usr/bin/env bash
# 麦当劳程序员创意开发大赛参赛仓库初始化脚本
# 用法（Git Bash / WSL / macOS Terminal）：
#   cd mcd-savvy && bash init_repo.sh
set -e

cd "$(dirname "$0")"

if [ -d .git ]; then
  echo "[跳过] 已是 git 仓库"
else
  git init -q
  echo "[完成] git 仓库已初始化"
fi

# 提交前确认没有泄露真实 Token（.gitignore 已拦截，这里再兜底）
# 只匹配 "Bearer "+20位以上字母数字的真实令牌；排除 ${...} / 占位符示例行
if git grep -n -iE "Bearer [A-Za-z0-9._-]{20,}" . --exclude-standard 2>/dev/null | grep -vE '\$\{|<你的Token>|MCP_TOKEN' >/dev/null; then
  echo "[警告] 检测到疑似明文 Token，请检查后再提交！" >&2
  exit 1
fi

git add .
git commit -q -m "init: 麦麦精算师 McSavvy 参赛 Skill（券临期预警+精准凑单+营养对账）" || echo "[提示] 无新变更可提交"

echo ""
echo "本地仓库就绪。下一步（GitHub 用户名 wzjxm，直接执行）："
echo "  git branch -M main"
echo "  git remote add origin https://github.com/wzjxm/mcd-savvy.git"
echo "  git push -u origin main"
echo ""
echo "推送后到赛事仓库提交 Issue（仓库地址已预填在 CONTEST_DECLARATION.md / README.md）。记得给仓库点 Star。"
