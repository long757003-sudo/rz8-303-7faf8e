# 奥园七期装修进度 · 对外发布仓

装修进度分享网页的**公开发布仓**：把知识库母本渲染出的脱敏静态单页部署成一个在线链接，微信传阅即可看，零账号零后端。做成独立仓是为了给「对外发布」这件事单独做版本管理。

## 这个仓和知识库的关系

- **母本(唯一事实来源)** = 知识库项目 `10-projects/奥园七期-装修/对外进度页/`。进度、账目、计划都在那里的 `data.json` / `data.internal.json`。
- **本仓** = 母本 `--release` 渲染产物的镜像，**只承载可公开的内容**，不在这里手改 `index.html`。改内容 → 改母本 data → 跑 `./sync.sh`。

## 安全红线

只发布 `index.html` + `assets/`(公开版引用到的脱敏图纸)。以下**永不进本仓**(已在 `.gitignore` 拦截，`sync.sh` 会二次校验)：

- `internal.html` —— 内部自看版，含商家/品牌/人名实名
- `data.internal.json` —— 内部账目原始数据

页面自带 `noindex`,不进搜索引擎;金额可对外,但商家/品牌/人名一律泛称(脱敏口径见母本 README)。

## 更新与发布

```bash
./sync.sh                       # 从母本重建 release 版并同步公开产物到本仓
open index.html                 # 本地预览
git add -A && git commit -m "…" && git push   # 发布(GitHub Pages 自动更新)
```

## 文件

- `index.html` —— 发布页(母本 release 产物,勿手改)
- `assets/` —— 页面引用的脱敏图纸
- `sync.sh` —— 从知识库母本同步公开产物(带红线校验)
- `.nojekyll` —— 让 GitHub Pages 原样托管
