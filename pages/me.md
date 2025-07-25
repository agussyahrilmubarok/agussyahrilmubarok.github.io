---
layout: page
title: Me
permalink: /
image: /assets/about/profile.jpg
---

<!-- <div>
    <img src="{{ site.baseurl }}/assets/about/profile.jpg" onmouseover="this.src='{{ site.baseurl }}/assets/about/profiles.jpg'" onmouseout="this.src='{{ site.baseurl }}/assets/about/profile.jpg'" class="rounded" width="200" height="200">
</div>
-->

<!-- Intro -->

{: style="text-align: justify" }
<h4>Hi, there 👋</h4>

{: style="text-align: justify" }
👨‍💻I'm Agus as <b>software engineer</b> based in Jakarta, Indonesia 🇮🇩. Software Engineer with a strong background in software development, system architecture, and cloud computing. Experienced in building and [optimizing production-grade applications](/), with a focus on improving efficiency, scalability, and performance. Proficient in backend development, distributed systems, and cloud infrastructure.

{: style="text-align: justify" }
🌱Build [Kratos (Go Microservice Framework)](https://go-kratos.dev/). 🔋 Learn DevOps Course on [Fast Campus](https://fastcampus.com/id). Read Book🏷️: <i>How to Create World-Class Agility, Reliability, and Security in Technology Organization</i> by Gene Kim, Patrick Debois, John Willis, Jez Humble. Systems Performance: Enterprise and the Cloud, 2nd Edition (2020) by Brendan Gregg.

You can reach me via <a href="{{ site.links.email }}">mrschwartx@gmail.com</a> and find me on:

{% include external_links.html %}

<hr>

<h4>🔧Tech stack I'm familiar with</h4>
<div style="text-align: justify;">
  {% for slug in site.data.skills.devIcons %}
    <img src="https://cdn.simpleicons.org/{{ slug }}" 
         style="margin: 4px; height: 30px; width: 30px;"
         onmouseover="this.src='https://cdn.simpleicons.org/{{ slug }}'"
         onmouseout="this.src='https://cdn.simpleicons.org/{{ slug }}'" />
  {% endfor %}
</div>

<hr>

<h4>💼 Related Experiences</h4>
{% assign experiences = site.data.experiences %}
{% for exp in experiences %}
<ul style="margin-top: 0; margin-bottom: 10px; text-align: justify; list-style:none;">
  <li>
    <b>{{ exp.company }}</b> | <i>{{ exp.date }}</i> <br />
    <b>{{ exp.title }}</b>
    {% for jobdesk in exp.jobdesk %}
    <ul style="margin-top: 0; margin-bottom: 0; text-align: justify;">
      <li>{{ jobdesk }}</li>
    </ul>
    {% endfor %}
  </li>
</ul>
{% endfor %}

<hr>

<h4>🎓 Education History</h4>
<ul style="list-style:none;">
    <li style="margin-bottom: 10px;">
        <b>Univeristas Islam Al-Ihya Kuningan</b> | 2020 - 2024<br> 
        <i>Computer Science - Informatics</i>
        <blockquote style="margin-top:0;margin-bottom:0;">
            <p style="margin-top:0;margin-bottom:0;">Thesis: Development of Prototype Automatic Waste Classification System based on Robotics with Machine Learning.</p>
        </blockquote>
    </li>
    <li style="margin-bottom: 10px;">
        <b>SMK Pertiwi Kuningan</b> | 2014 - 2017<br> 
        <i>Computer Network Engieneering</i> 
        <blockquote style="margin-top:0;margin-bottom:0;">
            <p style="margin-top:0;margin-bottom:0;">Final Project: IoT-based Smart School System: Design and Implementation.</p>
        </blockquote>
    </li>
</ul>

<hr>

<h4>🚀 Certifications</h4>
{% for item in site.data.certifications %}
<ul style="list-style:none; margin-top:0;margin-bottom:0;">
    <li><a href="{{ item.url }}" style="list-style: none; margin-left: 0; margin-top:0;margin-bottom:0;" target="_blank">{% include icons/link.html %} {{ item.title }}</a></li>
</ul>
{% endfor %}
