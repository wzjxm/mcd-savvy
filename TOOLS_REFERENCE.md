# 麦当劳 MCP 真实工具清单（实测）

> 来源：https://mcp.mcd.cn
> 实测方式：通过 Streamable HTTP + Bearer Token 执行 `tools/list`
> 实测时间：2026-10-25
> 工具总数：**35**

## 本 Skill 实际编排的核心工具（8 个）

| 工具名 | 用途 |
|---|---|
| `auto-bind-coupons` | 一键领取麦麦省可领券（写操作，需确认） |
| `query-my-coupons` | 查询我的券（含面额、到期日） |
| `available-coupons` | 查询当前可领券 |
| `query-nearby-stores` | 查询附近门店（storeCode / beCode） |
| `query-meals` | 查询门店可售餐品清单 |
| `query-meal-detail` | 查询单品/套餐详情与成分（营养核对用） |
| `calculate-price` | 含券后价精确核价 |
| `list-nutrition-foods` | 列出营养相关食品数据 |

## 完整 35 个工具（含刻意不调用的）

以下为服务端完整暴露的工具。本 Skill **刻意不调用**积分商城、抽奖、团餐、派对、外卖地址、商城订单等无关工具，以缩小 Agent 决策面、降低误触发。

```
campaign-calendar
query-store-coupons
query-order
query-promotions
mall-order-list
query-nearby-stores        ← 使用
order-list
list-nutrition-foods       ← 使用
delivery-query-addresses
delivery-query-stores
query-my-account
query-party-city
party-order-create
query-my-coupons           ← 使用
mall-order-detail
available-coupons          ← 使用
now-time-info
query-meal-assistance
draw-lottery
mall-product-detail
cancel-order
query-party-store
auto-bind-coupons          ← 使用
delivery-create-address
create-order
query-meals               ← 使用
query-meal-detail         ← 使用
calculate-price           ← 使用
query-survey-coupon
query-lottery-info
query-my-prizes
mall-create-order
mall-points-products
query-party-store-date
query-party-store-session
```

## 备注

- 服务端为无状态 Streamable HTTP 模式，不返回 `Mcp-Session-Id`，每次请求独立鉴权。
- 限流：600 次/分钟，超频返回 429。
- 工具命名前缀统一为 `mcp__mcd-mcp__*`（客户端接入后自动暴露，如 `mcp__mcd-mcp__query-my-coupons`）。
