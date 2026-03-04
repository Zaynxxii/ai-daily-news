#!/bin/bash
# AI Daily News - Complete Site Generator (English Version)

set -e

DIGEST_FILE="/root/.openclaw/workspace/ai-daily-digest/digest.md"
SITE_DIR="/root/.openclaw/workspace/ai-daily-news"
TEMPLATE_FILE="$SITE_DIR/template.html"
OUTPUT_FILE="$SITE_DIR/index.html"

if [ ! -f "$DIGEST_FILE" ]; then
    echo "❌ digest.md not found"
    exit 1
fi

echo "🚀 Generating AI Daily News website..."

# Extract statistics
TOTAL_SOURCES=$(grep -oP '\d+(?=/92)' "$DIGEST_FILE" | head -1 || echo "88")
TOTAL_ARTICLES=$(grep -oP '\d+(?= 篇)' "$DIGEST_FILE" | head -1 || echo "2496")
RECENT_ARTICLES=$(grep -oP '→ \K\d+(?= 篇)' "$DIGEST_FILE" | head -1 || echo "47")
TOP_N="15"

# Generate SEO tags (English)
SEO_TAGS="<span class=\"tag\">AI News</span><span class=\"tag\">Artificial Intelligence</span><span class=\"tag\">Machine Learning</span><span class=\"tag\">LLM</span><span class=\"tag\">Deep Learning</span><span class=\"tag\">Tech News</span><span class=\"tag\">Simon Willison</span><span class=\"tag\">Gemini</span><span class=\"tag\">Apple M5</span><span class=\"tag\">Open Source</span>"

# Generate trend summary (English)
TREND_SUMMARY="Today's AI highlights: 1) Apple unveils M5 chip family with updated MacBook lineup; 2) Google releases lightweight Gemini 3.1 Flash-Lite model; 3) Community discusses AI programming boundaries and LLM personality design."

# Generate Top 3 Cards HTML (English)
generate_top3() {
    cat << 'EOF'
        <div class="card top-3">
            <h2>🥇 Quoting Donald Knuth</h2>
            <div class="meta">simonwillison.net · 7 hours ago</div>
            <div class="summary">
                <p>Computing legend Donald Knuth discusses AI programming: "AI can write code, but programmers must understand every line." Simon Willison shares insights from Knuth's recent interview on the boundaries of AI-assisted programming.</p>
                <p><strong>Why read:</strong> A rare sober perspective in today's AI programming tool frenzy.</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/2026/Mar/3/donald-knuth/" target="_blank">Read More →</a></p>
        </div>
        
        <div class="card top-3">
            <h2>🥈 Gemini 3.1 Flash-Lite</h2>
            <div class="meta">simonwillison.net · 9 hours ago</div>
            <div class="summary">
                <p>Google releases lightweight Gemini model designed for low-cost, high-frequency scenarios. Significantly reduces costs while maintaining reasonable performance, ideal for applications requiring大量 API calls.</p>
                <p><strong>Why read:</strong> Important option for developers looking to scale AI API usage.</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/2026/Mar/3/gemini-31-flash-lite/" target="_blank">Read More →</a></p>
        </div>
        
        <div class="card top-3">
            <h2>🥉 GIF Optimization with WebAssembly</h2>
            <div class="meta">simonwillison.net · 1 day ago</div>
            <div class="summary">
                <p>Optimize GIFs in the browser using WebAssembly + Gifsicle, 10x faster. Compile Gifsicle to WebAssembly for client-side GIF optimization without server uploads.</p>
                <p><strong>Why read:</strong> Practical WebAssembly case study for frontend developers.</p>
            </div>
            <p style="margin-top: 15px;"><a href="https://simonwillison.net/guides/agentic-engineering-patterns/gif-optimization/" target="_blank">Read More →</a></p>
        </div>
EOF
}

# Generate Full List HTML (English)
generate_full_list() {
    cat << 'EOF'
        <div class="category">
            <h3>🍎 Apple News</h3>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-introduces-the-new-macbook-air-with-m5/" target="_blank">New MacBook Air With M5</a></h4>
                <div class="meta">Apple Newsroom · 10 hours ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-introduces-macbook-pro-with-all-new-m5-pro-and-m5-max/" target="_blank">MacBook Pro with M5 Pro/Max</a></h4>
                <div class="meta">Apple Newsroom · 11 hours ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.apple.com/newsroom/2026/03/apple-debuts-m5-pro-and-m5-max-to-supercharge-the-most-demanding-pro-workflows/" target="_blank">M5 Pro/Max Performance Details</a></h4>
                <div class="meta">Apple Newsroom · 13 hours ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.macrumors.com/2026/03/03/apple-accidentally-leaks-macbook-neo/" target="_blank">MacBook Neo Name Leak</a></h4>
                <div class="meta">MacRumors · 10 hours ago</div>
            </div>
        </div>
        
        <div class="category">
            <h3>🤖 AI/ML</h3>
            <div class="article-item">
                <h4><a href="https://seangoedecke.com/giving-llms-a-personality/" target="_blank">Giving LLMs a personality is just good engineering</a></h4>
                <div class="meta">seangoedecke.com · 1 day ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/2026/Mar/3/donald-knuth/" target="_blank">Quoting Donald Knuth</a></h4>
                <div class="meta">simonwillison.net · 7 hours ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/2026/Mar/3/gemini-31-flash-lite/" target="_blank">Gemini 3.1 Flash-Lite</a></h4>
                <div class="meta">simonwillison.net · 9 hours ago</div>
            </div>
        </div>
        
        <div class="category">
            <h3>🛠️ Tools & Projects</h3>
            <div class="article-item">
                <h4><a href="https://simonwillison.net/guides/agentic-engineering-patterns/gif-optimization/" target="_blank">GIF optimization with WASM</a></h4>
                <div class="meta">simonwillison.net · 1 day ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://www.jeffgeerling.com/blog/2026/pint-sized-macintosh-pico-micro-mac/" target="_blank">Pint-sized Macintosh</a></h4>
                <div class="meta">jeffgeerling.com · 1 day ago</div>
            </div>
            <div class="article-item">
                <h4><a href="https://daringfireball.net/2026/03/hazeover" target="_blank">HazeOver Window Tool</a></h4>
                <div class="meta">daringfireball.net · 1 day ago</div>
            </div>
        </div>
EOF
}

# Read template
TEMPLATE=$(cat "$TEMPLATE_FILE")

# Generate content
TOP3_HTML=$(generate_top3)
FULL_LIST_HTML=$(generate_full_list)
DATE=$(date +"%Y-%m-%d")

# Replace variables
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

# Write output
echo "$OUTPUT" > "$OUTPUT_FILE"

echo "✅ Website generated: $OUTPUT_FILE"
echo "📊 Stats: $TOTAL_SOURCES sources → $TOTAL_ARTICLES articles → $RECENT_ARTICLES recent → $TOP_N top picks"
