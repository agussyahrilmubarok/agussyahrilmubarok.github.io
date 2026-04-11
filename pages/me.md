---
layout: page
title: Me
permalink: /
image: /assets/about/profile.jpg
---

<!-- Intro -->
<h2>Hi, there 👋</h2>

I'm Agus Syahril Mubarok, a **Software Engineer** based on Jakarta, Indonesia. I specialize in backend development and cloud infrastructure - primarily with Go, Java, and C# - with hands-on experience building production-grade systems. I enjoy exploring new technologies and continuously learning to stay sharp in an ever-evolving industry.

🌱 Currently contributing to [Kratos](https://go-kratos.dev/), a Go Microservice Framework.

🔋 Learning DevOps on [Fast Campus](https://fastcampus.com/id).

📚 Currently reading: *The DevOps Handbook* by Gene Kim et al. and *Systems Performance* by Brendan Gregg.

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
