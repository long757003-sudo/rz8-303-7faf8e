#!/usr/bin/env bash
# 从知识库母本重建 release 版并同步到本仓（本仓只承载"可公开"产物）。
# 母本 = 知识库项目目录，是唯一事实来源；本仓不手改 index.html，改内容请改母本的 data.json。
# 安全红线：只同步 dist/index.html + 公开版引用到的脱敏图纸；internal.html / data.internal.json 永不进本仓。
set -euo pipefail

KB="/Users/longhaisen/Documents/Knowledge/10-projects/奥园七期-装修/对外进度页"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "▶ 在母本重建 release 版（去修改层、金额脱敏口径）"
node "$KB/build.mjs" --release

# 只挑公开版 index.html 里实际 src= 引用到的资源，逐一从 dist/assets 复制
echo "▶ 同步 index.html"
cp "$KB/dist/index.html" "$HERE/index.html"

echo "▶ 同步引用到的脱敏图纸"
rm -rf "$HERE/assets"; mkdir -p "$HERE/assets"
grep -oE 'src="assets/[^"]+"' "$HERE/index.html" | sed -E 's/src="assets\/([^"]+)"/\1/' | sort -u | while IFS= read -r f; do
  cp "$KB/dist/assets/$f" "$HERE/assets/$f"
  echo "  · $f"
done

# 红线校验：确保没有任何 internal 产物或数据文件混入本仓
if find "$HERE" -not -path '*/.git/*' \( -iname '*internal*' -o -iname 'data*.json' \) | grep -q .; then
  echo "✗ 检测到 internal / data.json 文件混入，已中止。请检查后再提交。" >&2
  exit 1
fi

echo "✓ 同步完成。预览：open index.html  ；发布：git add -A && git commit && git push"
