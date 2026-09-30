---
permalink: /
title: ""
excerpt: ""
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

{% if site.google_scholar_stats_use_cdn %}
{% assign gsDataBaseUrl = "https://cdn.jsdelivr.net/gh/" | append: site.repository | append: "@" %}
{% else %}
{% assign gsDataBaseUrl = "https://raw.githubusercontent.com/" | append: site.repository | append: "/" %}
{% endif %}
{% assign url = gsDataBaseUrl | append: "google-scholar-stats/gs_data_shieldsio.json" %}

<span class='anchor' id='about-me'></span>

I am a fourth-year Ph.D. student at [the School of Cyber Science and Engineering at Wuhan University](https://cse.whu.edu.cn/), advised by [Xiaochuan Shi](https://scholar.google.com/citations?user=o6CFxvoAAAAJ) and [Chao Ma](https://scholar.google.com/citations?user=KxM9fukAAAAJ). Now I am an intern of [X-Humanoid](https://x-humanoid.com). Previously, I was also an intern of [BeingBeyond](https://github.com/BeingBeyond) founded by [Zongqing Lu](https://z0ngqing.github.io/).

I received my Bachelor's degree in Computer Science and Technology with the School of Cyber Science and Engineering at Wuhan University, advised by Xiaochuan Shi. After two years of master's studies, I chose to pursue a doctorate through a Successive Postgraduate and Doctoral Program.

My research interest includes reinforcement learning and robotics. 


# 🔥 News
- *2026.09*: &nbsp;🎉 One paper is accepted by the Conference on Robot Learning (CoRL)
- *2025.11*: &nbsp;🎉 One paper is accepted by IEEE Robotics and Automation Letters (RA-L)
- *2024.09*: &nbsp;🎉 One paper is accepted by Journal of Computer Research and Development (计算机研究与发展)
- *2023.07*: &nbsp;🎉 One paper is accepted by 26th European Conference on Artificial Intelligence (ECAI 2023) 

# 📝 Selected Works

*:equal contribution; †: corresponding author; ‡: project leader

{% include publications.html %}

<!-- - [动态决策驱动的工控网络数据要素威胁检测方法](https://crad.ict.ac.cn/article/doi/10.7544/issn1000-1239.202440387)  

  **Zepeng Wang**, Chao Ma, Zhuangzhuang Zhang, Libing Wu, Xiaochuan Shi<sup>†</sup>

  Journal of Computer Research and Development (计算机研究与发展), 2024 -->


# 🎖 Honors and Awards
- *2025.07* College Postgraduate Excellence Scholarship
- *2024.10* Second Prize for Graduate Student Outstanding Academic Scholarship
- *2023.09* LeiJun Computer Science Scholarship
- *2022.07* First Prize for College Postgraduate Excellence Scholarship
- *2021.07* Second Prize for College Undergraduate Excellence Scholarship
- *2017.09* Freshman Scholarship of Wuhan University

# 📖 Educations
- *2023.09 - present*, Ph.D. student, School of Cyber Science and Engineering, Wuhan Univeristy, Wuhan.
- *2021.09 - 2023.08*, Master (apply for a Successive Postgraduate and Doctoral Program in the second year), School of Cyber Science and Engineering, Wuhan Univeristy, Wuhan.
- *2017.09 - 2021.06*, Undergraduate, School of Cyber Science and Engineering, Wuhan Univeristy, Wuhan.

<!-- # 💬 Invited Talks
- *2021.06*, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare aliquet ipsum, ac tempus justo dapibus sit amet. 
- *2021.03*, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare aliquet ipsum, ac tempus justo dapibus sit amet.  \| [\[video\]](https://github.com/) -->

# 💻 Internships

{% include internships.html %}

# 🧐 Reviewer Service
- *2026*, NIPS, ECCV, CoRL
- *2025*, RA-L
