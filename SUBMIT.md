# SUBMIT.md — 一键提交操作手册（麦当劳程序员创意开发大赛）

> 前置条件：已注册 GitHub 账户。截止 2026-10-25 23:59。
> 目标：保底拿 WorkBuddy 专项 3000 积分（条件：真实用 WB 开发 + 提交 workbuddy.md + 公开仓库 + Issue）。

## Step 0 — 填占位（把 <你的GitHub用户名> 全局替换）

需要替换的文件：`README.md`、`CONTEST_DECLARATION.md`、`SKILL.md`（author 字段）。
快速替换（在本目录执行，PowerShell）：
```powershell
$u = "你的GitHub用户名"
Get-ChildItem *.md | ForEach-Object {
  (Get-Content $_ -Raw) -replace '<你的GitHub用户名，?待填>|<待填>|<GitHub用户名>' , $u |
    Set-Content $_ -NoNewline
}
```

## Step 1 — 本地初始化仓库（含防 Token 泄露兜底）

```bash
cd mcd-savvy
bash init_repo.sh
```
> 该脚本会 `git init`、按 `.gitignore` 排除凭证、做一次含 Token 关键字的泄露预检后首次提交。

## Step 2 — 建公开仓库并推送（二选一）

**方式 A：GitHub 网页**
1. 打开 https://github.com/new ，仓库名填 `mcd-savvy`，选 **Public**，**不要**勾选初始化 README。
2. 记录仓库地址 `https://github.com/wzjxm/mcd-savvy.git`，然后：
```bash
git branch -M main
git remote add origin https://github.com/wzjxm/mcd-savvy.git
git push -u origin main
```

**方式 B：GitHub CLI（若已装 gh）**
```bash
gh repo create mcd-savvy --public --source=. --push
```

## Step 3 — 自星（确保 Star>0 进榜，覆盖"进榜奖"口径）

打开你的仓库页，点右上角 **Star**（自己点自己即可）。

## Step 4 — 提交参赛 Issue

1. 打开赛事仓库：https://github.com/M-China/mcd-developer-innovation-challenge
2. 点 **Issues → New issue**，选择官方参赛模板。
3. 按 `ISSUE_TEMPLATE.md` 内容填写：项目名称 + 项目地址 + 项目简介。
   - 项目名称：麦麦精算师 McSavvy
   - 项目地址：https://github.com/wzjxm/mcd-savvy
   - 项目简介：基于麦当劳官方 MCP 的消费优化助手，聚焦券临期预警 + 一键领取 + 营养约束下的精准凑单。
4. 提交 Issue。

## Step 5 — 复核清单（提交前逐项打勾）

- [ ] 仓库为 **Public**，且创建时间合规（2025-12-25 之后）
- [ ] 5 个必交文件齐全：`README.md` / `CONTEST_DECLARATION.md` / `MCP_INTEGRATION.md` / `mcp-config.example.json` / `workbuddy.md`
- [ ] `mcp-config.example.json` 只有 `${MCD_MCP_TOKEN}` 占位，**无真实 Token**
- [ ] `workbuddy.md` 已含真实 WorkBuddy 开发过程（含你客户端跑通的对话）
- [ ] 已自星（Star ≥ 1）
- [ ] Issue 已提交，含项目名称/地址/简介

## 时间线（参考）

| 时间 | 动作 |
|---|---|
| 拿到 GitHub 账户后 10 分钟内 | Step 0–2（建仓 push） |
| +10 分钟 | Step 3 自星 |
| 之前/并行 | 客户端跑通 Skill，导出对话补进 workbuddy.md |
| 23:00 前 | Step 4 发 Issue + Step 5 复核 |

## 安全提醒

- 真实 Token 只放本机客户端 `mcp.json`，**绝不进 Git**。
- 赛事结束后建议去 open.mcd.cn 控制台**轮换 Token**。
