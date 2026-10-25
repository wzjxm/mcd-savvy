# 麦麦精算师 McSavvy 🍟

> 基于麦当劳官方 MCP（open.mcd.cn）的个人消费优化 Skill · 参赛作品（1024 程序员节 · 麦当劳程序员创意开发大赛）

用 WorkBuddy 接上麦当劳 MCP，让 AI 帮你做三件事：**别让券过期、吃最划算的一餐、还别超标。**

## ✨ 功能亮点

- **券临期预警**：一键领取所有麦麦省券，自动标出 7 天内过期的"红色炸弹"。
- **精准凑单**：结合当前门店菜单与价格计算，找出"用掉临期券净收益最高"的组合，算出省了多少。
- **营养对账**：每餐热量/蛋白质/钠对比日均参考，提示是否超标——省钱不等于瞎吃。
- **聚焦痛点**：不堆砌 35 个接口，只编排 8 个核心高频工具，降低 Agent 误触发。

## 🛠 基于麦当劳 MCP 的真实能力

> 工具名均经 `mcp.mcd.cn` 实测核对（2026-10-25，共 35 个可用工具）。完整清单见 [TOOLS_REFERENCE.md](./TOOLS_REFERENCE.md)。

| 能力 | 调用的 MCP 工具 |
|---|---|
| 领券 | `auto-bind-coupons` |
| 查券 | `query-my-coupons` / `available-coupons` |
| 定门店 | `query-nearby-stores` |
| 菜单 | `query-meals` / `query-meal-detail` |
| 算价 | `calculate-price` |
| 营养 | `list-nutrition-foods` |
| 订单(可选) | `query-order` / `create-order`（需二次确认） |

## 🚀 快速开始

1. 到 [open.mcd.cn/mcp](https://open.mcd.cn/mcp)（**注意是 `/mcp` 子路径，不是首页**）用手机号验证登录（无独立注册，首次登录即建号），在「控制台」激活并复制 MCP Token。详见 [MCP_SETUP.md](./MCP_SETUP.md)。
2. 在 WorkBuddy 中添加 MCP Server：`mcd-mcp-server`（Streamable HTTP，Bearer Token）。详见 [MCP_SETUP.md](./MCP_SETUP.md)。
3. 导入本仓库的 `SKILL.md` 作为 WorkBuddy 技能。
4. 对 WorkBuddy 说："帮我看看有哪些券该用掉，今晚怎么吃最划算还不超标。"

### 使用示例

```
用户：我的麦麦省券快过期了，今晚想吃顿划算的，热量别太高
麦麦精算师：
【券体检】共 6 张券，其中 2 张临期（≤7天）
  🔴 临期：满30减12 到期 2026-10-28
  🔴 临期：中薯买一赠一 到期 2026-10-29
  ⚪ 充裕：巨无霸券…
【今晚建议吃掉】
  方案：用「满30减12」点 板烧鸡腿堡套餐(¥32) + 中薯买一赠一
  原价¥44 → 实付¥32，省¥12
  热量 ≈ 980 kcal ｜ 蛋白 38 g ｜ 钠 1650 mg（日均参考：热量2000 / 钠2000）
  营养提示：钠偏高，建议饮料换无糖可乐
```

## 📋 参赛信息

- 赛事：1024 程序员节 · 麦当劳程序员创意开发大赛（[M-China/mcd-developer-innovation-challenge](https://github.com/M-China/mcd-developer-innovation-challenge)）
- 开发工具：腾讯 WorkBuddy（享受 WorkBuddy 专项奖励）
- 参赛声明：见 [CONTEST_DECLARATION.md](./CONTEST_DECLARATION.md)

## ⚠️ 免责声明

本作品为个人开发者参赛作品，非麦当劳官方产品。所有下单/领券操作均通过用户本人授权的麦当劳会员 Token 执行，涉及支付前会二次确认。营养数据为参考值，不构成医疗或膳食建议。
