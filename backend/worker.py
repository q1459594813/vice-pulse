import asyncio
import aiohttp
import json
import os
from datetime import datetime

# 配置项 (可通过环境变量或配置文件注入)
RSSHUB_HOST = os.getenv("RSSHUB_HOST", "http://127.0.0.1:1200")
AI_BASE_URL = os.getenv("AI_BASE_URL", "https://api.deepseek.com/v1")
AI_API_KEY = os.getenv("AI_API_KEY", "")
AI_MODEL = os.getenv("AI_MODEL", "deepseek-chat")

# 监控信源路由列表
WATCH_FEEDS = [
    {"platform": "Reddit", "url": f"{RSSHUB_HOST}/reddit/subreddit/GTA6/new", "category": "community"},
    {"platform": "YouTube", "url": f"{RSSHUB_HOST}/youtube/user/@RockstarGames", "category": "official"},
    # 当配置好 Twitter Guest Token 后可开启:
    # {"platform": "X", "url": f"{RSSHUB_HOST}/twitter/user/RockstarGames", "category": "official"}
]

# 专属主编审阅提示词
SYSTEM_PROMPT = """你是一名资深游戏文化杂志主编，负责为《Vice Chronicle》严选有关 GTA 6（侠盗猎车手6）的动态。
你的唯一关注重点是：
1. 【官方重磅直发】：Rockstar 官方发布的预告、发售定档、跳票或技术研发专利。
2. 【线下实景营销】：全球（特别是迈阿密、洛杉矶、纽约等地）出现的实体巨幅手绘外墙、3D裸眼大屏、城市快闪等目击。

规则：
- 严格剔除同质化水贴、玩家日常无依据猜测、营销号谣言。
- 给出优先级评级：
  - 5 分：官方特大新闻或极度震撼的线下实锤（必须推送弹窗）
  - 3-4 分：高质量可信细节（收录进每日内参，不打扰弹窗）
  - 1-2 分：低价值内容（直接丢弃）

请输出标准的 JSON 格式：
{
  "should_include": true/false,
  "priority_score": 1-5,
  "category": "官方直发/线下营销/废弃",
  "clean_title": "精炼后的画报大标题",
  "editorial_summary": "100字左右的高质感杂志排版摘要",
  "editor_quote": "一句犀利的主编短评",
  "confidence": 95
}
"""

async def evaluate_post_with_ai(title: str, description: str, platform: str):
    """调用大模型过滤与改写文章"""
    if not AI_API_KEY:
        print("[AI] 未检测到 API Key，跳过大模型过滤")
        return None

    headers = {
        "Authorization": f"Bearer {AI_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": AI_MODEL,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"平台: {platform}\n标题: {title}\n详情: {description}"}
        ],
        "response_format": {"type": "json_object"}
    }

    async with aiohttp.ClientSession() as session:
        try:
            async with session.post(f"{AI_BASE_URL}/chat/completions", headers=headers, json=payload, timeout=30) as resp:
                if resp.status == 200:
                    data = await resp.json()
                    result = json.loads(data["choices"][0]["message"]["content"])
                    return result
        except Exception as e:
            print(f"[AI] 请求大模型失败: {e}")
            return None

async def poll_rsshub():
    """定时拉取 RSSHub 信号并审阅"""
    print(f"[{datetime.now()}] 正在轮询 RSSHub 增量信号...")
    async with aiohttp.ClientSession() as session:
        for feed in WATCH_FEEDS:
            try:
                async with session.get(feed["url"], timeout=10) as resp:
                    if resp.status == 200:
                        print(f"✓ 成功连接 {feed['platform']} 信源")
                    else:
                        print(f"⚠ 信源响应状态码: {resp.status}")
            except Exception as e:
                print(f"✗ 连接信源失败: {feed['platform']}, 原因: {e}")

if __name__ == "__main__":
    print("GTA 6 情报聚合调度器启动中...")
    asyncio.run(poll_rsshub())
