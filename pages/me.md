---
layout: page
title: Me
permalink: /
image: /assets/about/profile.jpg
---

<!-- Intro -->
<h2>Hi, there 👋</h2>

I'm Agus Syahril Mubarok, **Software Engineer** with a strong background in software development, system architecture, and cloud computing. Experienced in building and optimizing production-grade applications with a focus on efficiency, scalability, and performance.

| | |
|---|---|
| 🌱 Contributing | <a href="https://go-kratos.dev/" target="_blank">Kratos</a> — a Go Microservice Framework |
| 🔋 Learning     | DevOps at <a href="https://fastcampus.com/id" target="_blank">Fast Campus Indonesia</a> |
| 📚 Reading      | *The DevOps Handbook* — Gene Kim et al.<br>*Systems Performance* — Brendan Gregg |

You can reach me via <a href="{{ site.links.email }}">mrschwartx@gmail.com</a> and find me on:
{% include external_links.html %}

<hr>

<!-- Skills -->
![Tech Stack](https://skillicons.dev/icons?i=go,python,java,spring,cs,dotnet,cpp,kotlin,androidstudio,typescript,vue,react,express,php,laravel,dart,flutter,kafka,rabbitmq,postgres,mysql,mongo,firebase,linux,bash,docker,kubernetes,nginx,aws,gcp,azure,prometheus,grafana,openstack,tensorflow,matlab,pytorch,arduino,stackoverflow,devto,spotify)

<hr>

<!-- Experience -->
<h4>💼 Work Experiences</h4>
{% for exp in site.data.experiences %}
<div class="pf-exp-card">
  <div class="pf-exp-top">
    <div>
      <span class="pf-exp-company">
        {% if exp.url and exp.url != "/" %}
          <a href="{{ exp.url }}" target="_blank">{{ exp.company }}</a>
        {% else %}
        {{ exp.company }}
        {% endif %}
      </span>
      <span class="pf-exp-title">{{ exp.title }}</span>
    </div>
    <span class="pf-exp-date">{{ exp.date }}</span>
  </div>
  <ul class="pf-exp-ul">
    {% for jobdesk in exp.jobdesk %}
    <li>{{ jobdesk }}</li>
    {% endfor %}
  </ul>
</div>
{% endfor %}

<hr>

<!-- Education -->
<h4>🎓 Education</h4>
<div class="pf-edu-card">
  <div class="pf-edu-dot"></div>
  <div>
    <div class="pf-edu-top">
      <span class="pf-edu-school">Universitas Islam Al-Ihya Kuningan</span>
      <span class="pf-edu-date">2020 - 2024</span>
    </div>
    <div class="pf-edu-major">Computer Science - Informatics</div>
    <div class="pf-edu-thesis">"Development of Prototype Automatic Waste Classification System based on Robotics with Machine Learning."</div>
  </div>
</div>
<div class="pf-edu-card">
  <div class="pf-edu-dot"></div>
  <div>
    <div class="pf-edu-top">
      <span class="pf-edu-school">SMK Pertiwi Kuningan</span>
      <span class="pf-edu-date">2014 - 2017</span>
    </div>
    <div class="pf-edu-major">Computer Network Engineering</div>
    <div class="pf-edu-thesis">"IoT-based Smart School System: Design and Implementation."</div>
  </div>
</div>

<hr>

<!-- Certifications -->
<h4>🚀 Certifications</h4>
{% for item in site.data.certifications %}
<a href="{{ item.url }}" target="_blank" class="pf-cert-item">
  <span class="pf-cert-icon">↗</span>
  <span>{{ item.title }}</span>
</a>
{% endfor %}
