# workbuddy.md — WorkBuddy 开发过程记录

> 本文件记录「麦麦精算师 McSavvy」使用 **腾讯 WorkBuddy** 完成开发的完整过程与关键决策，用于麦当劳程序员创意开发大赛 **WorkBuddy 专项奖励** 的材料。
> 时间：2026-10-24 ～ 2026-10-25 ｜ 开发工具：腾讯 WorkBuddy（对话驱动，含联网检索、MCP 探测、代码/文档生成、自测）

---

## 1. 项目定位与差异化决策

- **背景**：赛事基于麦当劳官方 MCP 开发创意 Skill，按 GitHub Star 排名。开发前用 WorkBuddy 做竞品检索，发现"省钱/比价/点餐"赛道已高度拥挤（多个项目 600+ Stars），而"**券临期清理 + 营养约束凑单**"切角竞争少、且贴合"不浪费 + 吃得明白"的真实痛点。
- **定位**：不做"又一个点餐/省钱助手"，做「麦麦精算师 McSavvy」——**把快过期的券优先排进消费计划，并用真实营养数据兜底**。
- **刻意收窄工具面**：35 个可用工具中只编排 8 个核心工具，其余（积分商城、抽奖、团餐、派对、订单等）不调用，以降低 Agent 误触发与越权风险。

## 2. 环境接入（WorkBuddy 内完成）

1. 联网确认麦当劳 MCP 官方入口为 `open.mcd.cn/mcp`（首页是商户合作页，登录在子路径；无独立注册，手机号验证登录即建号）。
2. 在 `open.mcd.cn` 控制台激活，获取 MCP Token。
3. WorkBuddy 中把连接器配置写入 `~/.workbuddy/mcp.json`：
   ```json
   { "mcpServers": { "mcd-mcp-server": {
       "type": "streamableHttp",
       "url": "https://mcp.mcd.cn",
       "headers": { "Authorization": "Bearer ${MCD_MCP_TOKEN}" } } } }
   ```
4. 连通验证：`initialize` 返回 `mcd-mcp v1.0.0`，`tools/list` 返回 **35 个工具**，Token 有效。

## 3. 用 WorkBuddy 做的真实 MCP 只读验证（2026-10-25 实测）

> 用 Python 标准库以 Streamable HTTP 直连 `mcp.mcd.cn` 实测，确认真实工具名与返回结构，用于校准 SKILL.md（此前部分工具名为按规范推测）。

| 工具 | 入参要点 | 实测结果 |
|---|---|---|
| `tools/list` | — | ✅ 35 个工具；确认真实名 `query-meal-detail`（非 `meal-detail`） |
| `query-my-coupons` | pageSize≤200 | ✅ 返回账户持有券（示例："新人专享-中杯奶铁7折"） |
| `list-nutrition-foods` | 无 | ✅ `code 200`，返回 **160** 项营养表；字段 `energyKcal/protein/fat/carbohydrate/sodium/calcium`；示例：猪柳麦满分 308kcal、蛋白16g、钠781mg |
| `query-nearby-stores` | beType + searchType | ⚠️ searchType=2 按位置搜索依赖 GPS；无头调用命中 `600058`/`600050`。真机客户端有定位时可返回门店 |

**实测校准的关键规则**（已写入 SKILL.md「实测参数规则」）：
- `beType`：1=到店自提、2=麦乐送、5=得来速、6=团餐；`orderType`：1=到店、2=外送。
- 到店自提(beType=1)门店无 beCode，后续不传；得来速(beType=5)必须传 beCode。
- `query-my-coupons` 是"我持有的券"，官方明示不做门店/订单规则校验；"当前门店可用券"需另用 `query-store-coupons`。
- 餐品价以"元"计，一律以返回值为准，禁止口算。

## 4. 生成的交付物清单

| 文件 | 说明 |
|---|---|
| `SKILL.md` | 技能定义：触发词、三段能力、严格按序工作流、输出格式、边界、实测参数规则 |
| `README.md` | GitHub 项目页：功能、工具映射、使用示例、免责 |
| `CONTEST_DECLARATION.md` | 参赛声明（原创性/合规/敏感信息） |
| `MCP_INTEGRATION.md` | MCP 集成说明：Server、核心工具、调用流程、业务价值 |
| `mcp-config.example.json` | 脱敏配置示例（仅 `${MCD_MCP_TOKEN}` 占位，无真实 Token） |
| `workbuddy.md` | 本文件——WorkBuddy 开发过程记录 |
| `init_repo.sh` / `.gitignore` | 仓库初始化 + 防 Token/凭证误提交 |
| `ISSUE_TEMPLATE.md` | 赛事 Issue 提交模板 |
| `DEV_LOG_GUIDE.md` | 客户端开发对话导出指南 |

## 5. 工程取舍与红线

- **只读优先**：本记录中的验证全部为只读（查询/核价/营养）；`auto-bind-coupons`（领券）、下单等写操作在 Skill 内设为**二次确认后才执行**。
- **Token 安全**：真实 Token 只存在于本人 WorkBuddy 客户端 `mcp.json`，提交仓库的 `mcp-config.example.json` 仅留环境变量占位；`.gitignore` 拦截凭证与对话凭证误提交。
- **不编造**：查询失败即说明失败，不用训练记忆里的麦当劳信息顶替真实返回。

## 6. 待参赛者在本机客户端补充的部分

- 在个人 WorkBuddy 客户端 Trust 已配置的 `mcd-mcp-server`，按 `SKILL.md` 触发语跑通一次完整对话（真机有 GPS，门店/凑单/核价链路可完整走通）。
- 将该客户端开发对话导出，追加到本文件末尾（或作为本文件的对话原文附件），即构成完整的"用 WorkBuddy 开发"证据链。
