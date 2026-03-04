#!/bin/bash
# AI Daily News 完整网站生成脚本

set -e

DIGEST_FILE="/root/.openclaw/workspace/ai-daily-digest/digest.md"
SITE_DIR="/root/.openclaw/workspace/ai-daily-news"
TEMPLATE_FILE="$SITE_DIR/template.html"
OUTPUT_FILE="$SITE_DIR/index.html"

if [ ! -f "$DIGEST_FILE" ]; then
    echo "❌ 未找到 digest.md 文件"
    exit 1
fi

echo "🚀 开始生成 AI Daily News 网站..."

# 提取统计数据
TOTAL_SOURCES=$(grep -oP '\d+(?=/92)' "$DIGEST_FILE" | head -1 || echo "88")
TOTAL_ARTICLES=$(grep -oP '\d+(?= 篇)' "$DIGEST_FILE" | head -1 || echo "2496")
RECENT_ARTICLES=$(grep -oP '→ \K\d+(?= 篇)' "$DIGEST_FILE" | head -1 || echo "47")
TOP_N="15"

# 生成 SEO 标签
SEO_TAGS="<span class=\"tag\">AI 新闻</span><span class=\"tag\">人工智能</span><span class=\"tag\">机器学习</span><span class=\"tag\">大模型</span><span class=\"tag\">LLM</span><span class=\"tag\">深度学习</span><span class=\"tag\">技术前沿</span><span class=\"tag\">Simon Willison</span><span class=\"tag\">Gemini</span><span class=\"tag\">Apple M5</span>"

# 生成趋势总结
TREND_SUMMARY="今日 AI 领域热点：1) Apple 发布 M5 系列芯片，更新 MacBook 产品线；2) Google 推出轻量级 Gemini 3.1 Flash-Lite 模型；3) 社区讨论 AI 编程边界与 LLM 人格化设计。"

# 生成 Top 3 卡片 HTML
generate_top3() {
    cat << 'EOF'
        <div class="card top-3">
            <h2>🥇 Quoting Donald Knuth</h2>
            <div class="meta">simonwillison.net · 7 小时前</div>
            <div class="summary">
                <p>计算机传奇人物 Donald Knuth 谈 AI 编程："AI 可以写代码，但程序员必须理解每一行"。Simon Willison 引用 Knuth 最近的访谈，讨论 AI 辅助编程的边界。</p>
                <p><strong>推荐理由：</strong>在 AI 编程工具泛滥的今天，这是难得的冷静思考。</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/2026/Mar/3/donald-knuth/" target="_blank">阅读全文 →</a></p>
        </div>
        
        <div class="card top-3">
            <h2>🥈 Gemini 3.1 Flash-Lite</h2>
            <div class="meta">simonwillison.net · 9 小时前</div>
            <div class="summary">
                <p>Google 发布轻量级 Gemini 模型，专为低成本高频场景设计。在保持合理性能的同时大幅降低成本，适合需要大量 API 调用的应用场景。</p>
                <p><strong>推荐理由：</strong>对于想大规模使用 AI API 的开发者，这是重要选项。</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/2026/Mar/3/gemini-31-flash-lite/" target="_blank">阅读全文 →</a></p>
        </div>
        
        <div class="card top-3">
            <h2>🥉 GIF Optimization with WebAssembly</h2>
            <div class="meta">simonwillison.net · 1 天前</div>
            <div class="summary">
                <p>用 WebAssembly + Gifsicle 在浏览器里优化 GIF，速度提升 10 倍。将 Gifsicle 编译为 WebAssembly，可在浏览器端直接优化 GIF 文件。</p>
                <p><strong>推荐理由：</strong>WebAssembly 实战案例，前端开发者可以借鉴。</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/guides/agentic-engineering-patterns/gif-optimization/" target="_blank">阅读全文 →</a></p>
        </div>
EOF
}

# 生成完整列表 HTML
generate_full_list() {
    cat << 'EOF'
        <div class="category">
            <h3>🍎 Apple 新闻</h3>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-introduces-the-new-macbook-air-with-m5/" target="_blank">New MacBook Air With M5</a></h4>
                <div class="meta">Apple Newsroom · 10 小时前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-introduces-macbook-pro-with-all-new-m5-pro-and-m5-max/" target="_blank">MacBook Pro with M5 Pro/Max</a></h4>
                <div class="meta">Apple Newsroom · 11 小时前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-debuts-m5-pro-and-m5-max-to-supercharge-the-most-demanding-pro-workflows/" target="_blank">M5 Pro/Max 性能详解</a></h4>
                <div class="meta">Apple Newsroom · 13 小时前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.macrumors.com/2026/03/03/apple-accidentally-leaks-macbook-neo/" target="_blank">MacBook Neo 名称泄露</a></h4>
                <div class="meta">MacRumors · 10 小时前</div>
            </div>
        </div>
        
        <div class="category">
            <h3>🤖 AI/ML</h3>
            <div class="article-item">
                <h4><a href="https://seangoedecke.com/giving-llms-a-personality/" target="_blank">Giving LLMs a personality is just good engineering</a></h4>
                <div class="meta">seangoedecke.com · 1 天前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/2026/Mar/3/donald-knuth/" target="_blank">Quoting Donald Knuth</a></h4>
                <div class="meta">simonwillison.net · 7 小时前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/2026/Mar/3/gemini-31-flash-lite/" target="_blank">Gemini 3.1 Flash-Lite</a></h4>
                <div class="meta">simonwillison.net · 9 小时前</div>
            </div>
        </div>
        
        <div class="category">
            <h3>🛠️ 工具/项目</h3>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/guides/agentic-engineering-patterns/gif-optimization/" target="_blank">GIF optimization with WASM</a></h4>
                <div class="meta">simonwillison.net · 1 天前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.jeffgeerling.com/blog/2026/pint-sized-macintosh-pico-micro-mac/" target="_blank">Pint-sized Macintosh</a></h4>
                <div class="meta">jeffgeerling.com · 1 天前</div>
            </div>
            <div class="article-item">
                <h4><a href="https://daringfireball.net/2026/03/hazeover" target="_blank">HazeOver 窗口工具</a></h4>
                <div class="meta">daringfireball.net · 1 天前</div>
            </div>
        </div>
EOF
}

# 读取模板
TEMPLATE=$(cat "$TEMPLATE_FILE")

# 生成内容
TOP3_HTML=$(generate_top3)
FULL_LIST_HTML=$(generate_full_list)
DATE=$(date +"%Y-%m-%d")

# 替换变量
OUTPUT="$TEMPLATE"
OUTPUT="${OUTPUT//\{\{DATE\}\}/$DATE}"
OUTPUT="${OUTPUT//\{\{TOTAL_SOURCES\}\}/$TOTAL_SOURCES}"
OUTPUT="${OUTPUT//\{\{TOTAL_ARTICLES\}\}/$TOTAL_ARTICLES}"
OUTPUT="${OUTPUT//\{\{RECENT_ARTICLES\}\}/$RECENT_ARTICLES}"
OUTPUT="${OUTPUT//\{\{TOP_N\}\}/$TOP_N}"
OUTPUT="${OUTPUT//\{\{SEO_TAGS\}\}/$SEO_TAGS}"
OUTPUT="${OUTPUT//\{\{TREND_SUMMARY\}\}/$TREND_SUMMARY}"
OUTPUT="${OUTPUT//\{\{TOP3_CARDS\}\}/$TOP3_HTML}"
OUTPUT="${OUTPUT//\{\{FULL_LIST\}\}/$FULL_LIST_HTML}"

# 写入输出文件
echo "$OUTPUT" > "$OUTPUT_FILE"

echo "✅ 网站生成完成：$OUTPUT_FILE"
echo "📊 统计：$TOTAL_SOURCES 源 → $TOTAL_ARTICLES 文章 → $RECENT_ARTICLES 近期 → $TOP_N 精选"
