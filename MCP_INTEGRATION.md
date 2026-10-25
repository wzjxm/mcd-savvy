# MCP 集成说明（MCP_INTEGRATION）

## 1. 实际使用的 MCP Server

| 项 | 值 |
|---|---|
| Server 名称 | `mcd-mcp-server` |
| 提供方 | 麦当劳中国官方 MCP（`open.mcd.cn/mcp`） |
| 接入方式 | Streamable HTTP |
| 端点（URL） | `https://mcp.mcd.cn` |
| 鉴权 | `Authorization: Bearer <TOKEN>`（Token 在 open.mcd.cn 控制台激活后获取） |
| 协议版本 | 2024-11-05（MCP 标准） |
| 实测状态 | ✅ 已连通，`initialize` 返回 `mcd-mcp v1.0.0`，共 35 个工具可用 |

## 2. 本 Skill 调用的核心工具（8 个）

「麦麦精算师 McSavvy」刻意只调用与"券临期清理 + 精准凑单 + 营养对账"直接相关的 8 个工具，避免宽工具面带来的 Agent 误触发：

| 工具名（真实） | 用途 | 调用阶段 |
|---|---|---|
| `auto-bind-coupons` | 一键领取账户下可领的麦麦省优惠券（写操作，先二次确认） | 券体检 |
| `query-my-coupons` | 拉取当前全部可用券，提取券名、面额/折扣、到期日 | 券体检 |
| `query-nearby-stores` | 确定用户所在/指定门店（storeCode、beCode） | 门店定位 |
| `query-meals` | 拉取该门店可售餐品清单（分类、餐品编码、标签） | 凑单 |
| `calculate-price` | 对候选组合计算含优惠后的应付总价 | 凑单 |
| `list-nutrition-foods` | 列出营养数据可查的餐品范围 | 营养对账 |
| `query-meal-detail` | 回查具体餐品营养成分（热量/蛋白/钠），忌口过敏必须回查 | 营养对账 |
| （门店/餐品辅助查询工具按需补充） | 支撑上述主链路的参数获取 | 各阶段 |

> 说明：其余 27 个工具（积分商城、抽奖、团餐、主题活动、订单等）不在本 Skill 编排范围内，属刻意不调用，以降低误触发与越权风险。

## 3. 调用流程（业务价值闭环）

```
[1] auto-bind-coupons → query-my-coupons
        │  提取每张券：名称 / 面额或折扣 / 到期日
        ▼
[2] 临期识别：距到期 ≤7 天 → 标记为"红色炸弹"（优先消耗对象）
        ▼
[3] query-nearby-stores → 选定门店（storeCode / beCode）
        ▼
[4] query-meals → 取该门店可售餐品
        ▼
[5] calculate-price × 每张临期券 → 生成候选组合，挑"省最多 + 凑单成本最低"
        ▼
[6] list-nutrition-foods + query-meal-detail → 对推荐组合做营养对账
        ▼
[7] 输出：临期券清单 + 最优凑单方案 + 营养提示（结构化）
```

## 4. 业务价值

- **不浪费**：把"快过期的券"优先排进消费计划，解决用户"券忘了用"的普遍痛点。
- **算得清**：用 `calculate-price` 实测券后价，而非凭记忆口算，避免优惠规则误算。
- **吃得明**：用 `query-meal-detail` 真实回查营养，对忌口/控卡人群给出可执行提示。
- **分得清边界**：领券/下单等写操作用二次确认护栏，查询/核价类只读执行，安全可控。

## 5. 接入配置（脱敏示例）

见本仓库 `mcp-config.example.json`，Token 一律以环境变量占位，**禁止写入真实 Token**。
