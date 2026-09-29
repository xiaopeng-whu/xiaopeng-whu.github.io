# 论文列表与配图

论文信息在 `_data/publications.yml` 中维护，顺序即首页顺序。作者字段支持 Markdown 加粗和 HTML 上标。

有项目页时填写可选的 `webpage` 字段，开源仓库填写 `code` 字段。链接按 Paper、Webpage、Code 排列，仅显示已填写的入口，分别使用文档、地球和 GitHub 图标。

- 有图：填写 `image`、`image_alt` 和 `image_source`。图片完整展示，点击缩略图打开原图，不再单独显示 Figure 入口。
- 无图：省略以上字段，自动显示 `label`（简称）和 `topic`（研究主题）组成的文字封面。
- 图片存放在 `images/publications/`；桌面使用左右布局，640px 及以下使用上下布局。
- 桌面图片统一宽度 220px，高度随原图比例自适应，无外框或内边距；`image_width` / `image_height` 填原图像素尺寸，用于加载前预留正确比例的空间。
- PDF 配图按完整图形区域提取，保留所有子图、图例和坐标标签，不包含正文及图注；图形内容未修改。

## 当前图片来源

| 文件 | 选图 | 原始地址 |
| --- | --- | --- |
| fast-figure1.png | FAST CoRL 版本首页 Figure 1，遥操作与快速适应技能展示 | 作者本地 `FAST-CORL2026/FAST_CoRL_2026.pdf`，第 1 页 |
| crosser.png | CROSSER Figure 2，完整方法框架 | 作者本地 RA-L 终版 PDF，第 4 页；https://doi.org/10.1109/LRA.2025.3630544 |
| rlpf.png | RLPF Figure 1，仿真与真机效果对比 | https://arxiv.org/html/2506.12769v1/first_fig_right_crop.png |
| being-m07-figure1.png | Being-M0.7 首页 Figure 1，总览图 | https://research.beingbeyond.com/being-m07/being-m07.pdf ，第 1 页 |
| plat.png | PLAT Figure 1，方法框架图 | https://arxiv.org/html/2609.25754v1/framework.png |
| ccpo.png | CCPO Figure 2，Pendulum 与 Reacher 的奖励和成本曲线 | https://research-management.mq.edu.au/ws/portalfiles/portal/347956034/342699606.pdf ，第 6 页 |

当前 6 篇论文均使用真实配图。CCPO 暂用 Figure 2：同时呈现任务回报和约束成本，后续可替换。FAST 的 CoRL 版本首图与之前 arXiv HTML v1 的 Figure 1 不同，此处按作者要求使用 CoRL 版本首图。
