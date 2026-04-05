---
layout: page
title: Projects
permalink: /projects/
---

{% for project in site.data.projects %}
<div>
    {% if project.image_url and project.image_url != "" %}
    <img src="{{ project.image_url }}" class="rounded" width="100" height="100">
    {% endif %}
    <h2>{{ project.name }}</h2>
    <div>
        {% for tag in project.tags %}
        <span class="badge badge-pill">{{ tag }}</span>
        {% endfor %}
    </div>
    <p>{{ project.description }}</p>
    {% if project.url_path and project.url_path != "" %}
        <a href="{{ project.url_path }}" class="pf-project-link">
          Read More {% include icons/chevron-right.html %}
        </a>
    {% endif %}
    <p class="text-muted"><i>{{ project.muted }}</i></p>
</div>
{% unless forloop.last %}<hr>{% endunless %}
{% endfor %}