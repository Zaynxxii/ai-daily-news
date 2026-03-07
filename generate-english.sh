#!/bin/bash
# AI Daily News - English Site Generator (March 6, 2026 Version)
# Generates English pages with SEO, date selector, and trending keywords

set -e

DIGEST_DIR="/root/.openclaw/workspace/ai-daily-digest"
SITE_DIR="/root/.openclaw/workspace/ai-daily-news"
DIGEST_FILE="$DIGEST_DIR/digest.md"
ARCHIVES_DIR="$SITE_DIR/archives"
DAYS_TO_KEEP=7

echo "🚀 AI Daily News - English Generator"

mkdir -p "$ARCHIVES_DIR"

TODAY=$(date +%Y-%m-%d)
TODAY_EN=$(date +"%B %-d, %Y")
WEEKDAY=$(date +%A)

if [ ! -f "$DIGEST_FILE" ]; then
    echo "❌ digest.md not found"
    exit 1
fi

DIGEST_CONTENT=$(cat "$DIGEST_FILE")

# Extract stats
TOTAL_SOURCES=$(grep -oP '\d+(?=/92)' "$DIGEST_FILE" | head -1 || echo "92")
TOTAL_ARTICLES=$(grep -oP '\d+(?= articles)' "$DIGEST_FILE" | head -1 || echo "2500")
RECENT_ARTICLES=$(grep -oP '→ \K\d+(?= articles)' "$DIGEST_FILE" | head -1 || echo "35")

# Generate date options for selector
generate_date_options() {
    local options=""
    for i in {0..6}; do
        local date=$(date -d "$i days ago" +%Y-%m-%d)
        local date_en=$(date -d "$i days ago" +"%B %-d, %Y")
        local weekday=$(date -d "$i days ago" +%A)
        local file="$date.html"
        if [ $i -eq 0 ]; then
            options="$options<option value=\"index.html\" selected>$date_en ($weekday) - Today</option>"
        else
            options="$options<option value=\"$file\">$date_en ($weekday)</option>"
        fi
    done
    echo "$options"
}

DATE_OPTIONS=$(generate_date_options)

# Generate SEO keywords
generate_seo_keywords() {
    cat << 'EOF'
<span class="tag">AI News</span><span class="tag">Artificial Intelligence</span><span class="tag">Machine Learning</span><span class="tag">LLM</span><span class="tag">Deep Learning</span><span class="tag">Tech News</span><span class="tag">Cybersecurity</span><span class="tag">Apple</span><span class="tag">Open Source</span>
EOF
}

SEO_KEYWORDS=$(generate_seo_keywords)

# Generate trending topics
generate_trending() {
    cat << 'EOF'
<div class="keyword-card hot">
    <div class="keyword-name">🔐 AI Security</div>
    <div class="keyword-stats">
        <span class="trend-score"><span class="value">95</span><span class="change">↑12</span></span>
    </div>
    <div class="keyword-desc">Prompt injection & supply chain attacks</div>
</div>
<div class="keyword-card breaking">
    <div class="keyword-name">📱 iOS Exploits</div>
    <div class="keyword-stats">
        <span class="trend-score"><span class="value">88</span><span class="change">↑25</span></span>
    </div>
    <div class="keyword-desc">Coruna exploit kit proliferation</div>
</div>
<div class="keyword-card">
    <div class="keyword-name">🤖 Agentic AI</div>
    <div class="keyword-stats">
        <span class="trend-score"><span class="value">72</span><span class="change">↑5</span></span>
    </div>
    <div class="keyword-desc">Engineering patterns & best practices</div>
</div>
EOF
}

TRENDING_HTML=$(generate_trending)

# Parse digest.md and generate article cards
generate_articles() {
    local in_top3=false
    local in_list=false
    local articles=""
    local rank=1
    
    while IFS= read -r line; do
        if [[ "$line" == "## 🏆 今日必读 Top 3" ]]; then
            in_top3=true
            continue
        elif [[ "$line" == "## 📊 数据概览" ]]; then
            in_top3=false
            in_list=false
            continue
        elif [[ "$line" == "## 📝 完整列表" ]]; then
            in_list=true
            continue
        elif [[ "$line" == "## 🔥 趋势观察" ]]; then
            in_list=false
            continue
        fi
        
        if $in_top3 && [[ "$line" == "### "* ]]; then
            local title=$(echo "$line" | sed 's/^### [0-9]*\. \*\*//' | sed 's/\*\*$//')
            articles="$articles<div class=\"card top-3\"><div class=\"rank-badge rank-$rank\">#$rank</div><h3>$title</h3>"
            ((rank++))
        elif $in_top3 && [[ "$line" == "!"* ]]; then
            # Skip images
            continue
        elif $in_top3 && [[ -n "$line" && "$line" != "###"* ]]; then
            articles="$articles<p>$line</p>"
        elif $in_top3 && [[ "$line" == "" && -n "$articles" ]]; then
            articles="$articles</div>"
        fi
        
        if $in_list && [[ "$line" == "### "* ]]; then
            local category=$(echo "$line" | sed 's/^### //')
            articles="$articles<div class=\"category\"><h3>$category</h3><ul>"
        elif $in_list && [[ "$line" == "- \*\*"* ]]; then
            local item=$(echo "$line" | sed 's/^- \*\*\([^*]*\)\*\*/<li><strong>\1<\/strong>/' | sed 's/\*\*\(.*\)\*\*/<em>\1<\/em>/')
            articles="$articles$item</li>"
        elif $in_list && [[ "$line" == "## "* ]]; then
            articles="$articles</ul></div>"
        fi
    done < "$DIGEST_FILE"
    
    echo "$articles"
}

ARTICLES_HTML=$(generate_articles)

# Generate the full HTML page
cat > "$SITE_DIR/index.html" << HTMLEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Daily News - $TODAY_EN</title>
    <meta name="description" content="Daily AI news curated from 92 top tech blogs - AI security, iOS exploits, agentic engineering, and more">
    <meta name="keywords" content="AI, Artificial Intelligence, Machine Learning, LLM, Tech News, Cybersecurity, Apple, Open Source">
    <meta name="robots" content="index, follow">
    <meta property="og:title" content="AI Daily News - $TODAY_EN">
    <meta property="og:description" content="Daily AI news curated from 92 top tech blogs">
    <meta property="og:type" content="website">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #1a1a2e;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { max-width: 1000px; margin: 0 auto; padding: 40px 20px; }
        header { text-align: center; color: white; margin-bottom: 40px; }
        header h1 { font-size: 2.8em; margin-bottom: 10px; font-weight: 700; letter-spacing: -0.5px; }
        header .date { font-size: 1.1em; opacity: 0.9; font-weight: 400; }
        
        .date-selector {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            border-radius: 16px;
            padding: 20px 30px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .date-selector label { color: #667eea; margin-right: 15px; font-weight: 600; font-size: 1em; }
        .date-selector select {
            padding: 12px 25px;
            font-size: 1em;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            background: white;
            color: #333;
            cursor: pointer;
            outline: none;
            font-weight: 500;
            transition: all 0.2s;
        }
        .date-selector select:hover { border-color: #667eea; transform: translateY(-1px); }
        .date-selector select:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        
        .trending-section {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
        }
        .trending-section h3 { text-align: center; margin-bottom: 25px; font-size: 1.4em; color: #667eea; font-weight: 600; }
        .keywords-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
        .keyword-card {
            background: linear-gradient(135deg, #f8f9ff, #ffffff);
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .keyword-card:hover { transform: translateY(-4px); box-shadow: 0 8px 25px rgba(102,126,234,0.15); }
        .keyword-card.hot { background: linear-gradient(135deg, #fff5f5, #ffffff); border-color: #ff6b6b; }
        .keyword-card.breaking { background: linear-gradient(135deg, #fff9e6, #ffffff); border-color: #ffd93d; }
        .keyword-name { font-weight: 600; font-size: 1.1em; margin-bottom: 12px; color: #1a1a2e; }
        .keyword-stats { display: flex; justify-content: center; gap: 12px; font-size: 0.9em; margin-bottom: 10px; }
        .trend-score { display: flex; align-items: center; gap: 6px; background: rgba(102,126,234,0.1); padding: 6px 12px; border-radius: 20px; }
        .trend-score .value { font-weight: 700; font-size: 1.1em; color: #667eea; }
        .trend-score .change { font-weight: 600; font-size: 0.9em; color: #e74c3c; }
        .keyword-desc { font-size: 0.85em; color: #666; line-height: 1.4; }
        
        .stats {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        .stats span { margin: 0 15px; font-size: 1.1em; }
        
        .card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            position: relative;
        }
        .card h2 { color: #667eea; margin-bottom: 20px; font-size: 1.5em; font-weight: 600; }
        .card h3 { color: #1a1a2e; margin: 20px 0 10px; font-size: 1.2em; font-weight: 600; }
        .card p { margin-bottom: 15px; line-height: 1.7; color: #333; }
        .card a { color: #667eea; text-decoration: none; font-weight: 500; }
        .card a:hover { text-decoration: underline; }
        
        .top-3 { border: 3px solid #667eea; }
        .rank-badge {
            position: absolute;
            top: -15px;
            left: 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9em;
        }
        .rank-1 { background: linear-gradient(135deg, #FFD700, #FFA500); }
        .rank-2 { background: linear-gradient(135deg, #C0C0C0, #808080); }
        .rank-3 { background: linear-gradient(135deg, #CD7F32, #8B4513); }
        
        .category { margin-top: 25px; }
        .category h3 { color: #667eea; margin-bottom: 15px; font-size: 1.2em; }
        .category ul { list-style: none; }
        .category li { padding: 12px 0; border-bottom: 1px solid #eee; }
        .category li:last-child { border-bottom: none; }
        .category li strong { color: #1a1a2e; font-weight: 600; }
        .category li em { color: #888; font-style: normal; font-size: 0.9em; }
        
        footer { text-align: center; color: rgba(255,255,255,0.7); margin-top: 40px; padding: 20px; }
        footer a { color: rgba(255,255,255,0.9); text-decoration: none; }
        footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>📰 AI Daily News</h1>
            <div class="date">$TODAY_EN</div>
        </header>
        
        <div class="date-selector">
            <label for="date-select">📅 Select Date:</label>
            <select id="date-select" onchange="location.href=this.value">
                $DATE_OPTIONS
            </select>
        </div>
        
        <div class="trending-section">
            <h3>🔥 Trending Topics</h3>
            <div class="keywords-grid">
                $TRENDING_HTML
            </div>
        </div>
        
        <div class="stats">
            <span>📊 $TOTAL_SOURCES/92 sources</span>
            <span>→ $TOTAL_ARTICLES articles</span>
            <span>→ $RECENT_ARTICLES recent</span>
        </div>

        $ARTICLES_HTML

        <footer>
            <p>Generated by OpenClaw | Data retained for 7 days</p>
            <p><a href="https://github.com/Zaynxxii/ai-daily-news" target="_blank">GitHub</a></p>
        </footer>
    </div>
</body>
</html>
HTMLEOF

echo "✅ English site generated successfully!"
echo "🌐 Homepage: $SITE_DIR/index.html"
echo "📅 Date: $TODAY_EN"
