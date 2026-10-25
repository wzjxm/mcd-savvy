# 麦当劳 MCP 接入指南（WorkBuddy）

> 官方文档：https://open.mcd.cn/mcp/doc

## ⚠️ 关键：入口是 /mcp 子路径，不是首页

- 首页 `https://open.mcd.cn` 是「商户合作」页面，**没有 MCP 登录入口**。
- 正确的 MCP 开放平台地址是：**`https://open.mcd.cn/mcp`**（务必带 `/mcp`）。
- 该平台**无独立注册流程**：直接用手机号验证登录即可，首次登录自动建号，不需要先"注册"。

## 1. 申请 Token（约 3 分钟，仅本人可做）

1. 浏览器打开 **https://open.mcd.cn/mcp**。
2. 点右上角 **【登录】** → 用**手机号验证登录**（收短信验证码）。
3. 登录成功后，右上角「登录」按钮变成 **「控制台」**。
4. 点 **【控制台】** → 弹窗中点 **【激活】** → 同意服务协议 → **一键复制 Token**。
5. Token 形如 `Bearer xxxx`，是绑定你本人麦当劳会员账号的访问凭证。

## 2. 在 WorkBuddy 中接入 MCP Server

麦当劳 MCP 仅支持 **Streamable HTTP** 传输（老客户端若只支持 SSE 无法连接）。

在 WorkBuddy：左侧边栏「专家 · 技能 · 连接器」→「连接器」→ 右上角「自定义连接器」→「配置 MCP」，粘贴：

```json
{
  "mcpServers": {
    "mcd-mcp-server": {
      "type": "streamablehttp",
      "url": "https://mcp.mcd.cn",
      "headers": {
        "Authorization": "Bearer 你的MCP_TOKEN"
      }
    }
  }
}
```

> 把 `你的MCP_TOKEN` 换成第 1 步复制的值，保存后回到列表**启用** `mcd-mcp-server`。
> 若客户端提示协议类型不支持，可把 `"type"` 试改为 `"streamable-http"`。
> WorkBuddy 也支持把配置合并进 `~/.workbuddy/mcp.json` 的 `mcpServers` 字段，重启客户端生效。

## 3. 验证连通

在 WorkBuddy 对话中输入："查询我附近的麦当劳门店"。若返回门店列表，说明 MCP 已连通，且客户端会自动暴露全部 `mcp__mcd-mcp__*` 工具（约 35 个）。

## 4. 导入 Skill

1. 将本仓库 `SKILL.md` 复制为 WorkBuddy 的一个技能（按 WorkBuddy 技能导入流程）。
2. 或直接在对话中以自然语言描述需求，WorkBuddy 会调用麦当劳 MCP 工具完成。

## ⚠️ 安全提示

- Token 等同你本人账号的操作凭证，**切勿写入代码、README、Issue 或日志**；仓库里的示例一律用占位符。
- 推荐放 WorkBuddy 客户端私有配置或本机环境变量（`MCD_MCP_TOKEN`），不要明文进 Git。
- 限流：600 次/分钟，超出返回 429，请控制调用频率。
- 涉及领券、下单等写操作前必须你本人确认。
