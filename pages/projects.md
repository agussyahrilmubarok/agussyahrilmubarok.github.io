---
layout: page
title: Projects
permalink: /projects/
---

{% assign top = site.data.topprojects %}
{% if top.size > 0 %}
<h4 class="mb-3">⭐ Top Projects</h4>
<div class="row row-cols-1 row-cols-md-2 g-3 mb-4">
    {% for project in top %}
    <div class="col">
        <div class="pf-top-card position-relative">
            {% if project.image_url and project.image_url != "" %}
            <img src="{{ project.image_url | relative_url }}" alt="{{ project.name }}" class="pf-top-img rounded" width="48" height="48" onerror="this.style.display='none'">
            {% endif %}
            <h5 class="pf-top-title">{{ project.name }}</h5>
            <p class="pf-top-desc">{{ project.description }}</p>
            <div class="pf-top-tags">
                {% for tag in project.tags limit: 4 %}
                <span class="badge badge-pill">{{ tag }}</span>
                {% endfor %}
            </div>
            <div class="pf-top-foot">
                <span class="text-muted"><i>{{ project.muted }}</i></span>
                {% if project.url_path and project.url_path != "" %}
                <a href="{{ project.url_path | relative_url }}" class="pf-project-link stretched-link">
                    Read More {% include icons/chevron-right.html %}
                </a>
                {% endif %}
            </div>
        </div>
    </div>
    {% endfor %}
</div>
<hr>
{% endif %}

{% assign total = site.data.projects | size %}
<div class="d-flex justify-content-between align-items-baseline mb-3">
    <h4 class="mb-0">All Projects</h4>
    <span class="text-muted">{{ total }} project{% if total != 1 %}s{% endif %}</span>
</div>

{% for project in site.data.projects %}
<div>
    {% if project.image_url and project.image_url != "" %}
    <img src="{{ project.image_url | relative_url }}" alt="{{ project.name }}" class="rounded" width="100" height="100" onerror="this.style.display='none'">
    {% endif %}
    <h2>{{ project.name }}</h2>
    <div>
        {% for tag in project.tags %}
        <span class="badge badge-pill">{{ tag }}</span>
        {% endfor %}
    </div>
    <p>{{ project.description }}</p>
    {% if project.url_path and project.url_path != "" %}
    <a href="{{ project.url_path | relative_url }}" class="pf-project-link">
        Read More {% include icons/chevron-right.html %}
    </a>
    {% endif %}
    <p class="text-muted"><i>{{ project.muted }}</i></p>
</div>
{% unless forloop.last %}<hr>{% endunless %}
{% endfor %}