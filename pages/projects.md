---
layout: page
title: Projects
permalink: /projects/
---

<style>
.pf-search { margin-bottom: 1.75rem; }
.pf-search [hidden], .pf-project[hidden], .pf-search-empty[hidden] { display: none !important; }
.pf-search .pf-search-input { display: block; width: 100%; box-sizing: border-box; padding: 0.75rem 1rem 0.75rem 2.75rem; border: 1px solid rgba(142,142,147,0.45); border-radius: 12px; background-color: var(--background-color); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='%238e8e93' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Ccircle cx='11' cy='11' r='7'/%3E%3Cpath d='m20 20-3.5-3.5'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 1rem center; color: var(--text-color); font: inherit; -webkit-appearance: none; appearance: none; }
.pf-search .pf-search-input:focus { outline: 2px solid #5e5ce6; outline-offset: 1px; border-color: transparent; }
.pf-search .pf-filters { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 1rem; }
.pf-search .pf-filter { -webkit-appearance: none; appearance: none; border: 0; border-radius: 999px; background: var(--secondary-background-color); color: var(--text-color); padding: 0.3rem 0.9rem; font: inherit; font-size: 0.8rem; line-height: 1.4; cursor: pointer; transition: background-color 0.15s, color 0.15s; }
.pf-search .pf-filter:hover { background: rgba(94,92,230,0.2); }
.pf-search .pf-filter.is-active { background: #5e5ce6; color: #ffffff; }
.pf-search .pf-search-meta { display: flex; align-items: center; gap: 0.75rem; margin-top: 1rem; font-size: 0.8rem; color: var(--secondary-text-color); }
.pf-search .pf-reset { -webkit-appearance: none; appearance: none; border: 0; background: none; padding: 0; font: inherit; color: #5e5ce6; cursor: pointer; }
.pf-search .pf-reset:hover { text-decoration: underline; }
.pf-search-empty { padding: 2rem 0; text-align: center; color: var(--secondary-text-color); }
.pf-project { display: flex; align-items: flex-start; gap: 1.25rem; box-sizing: border-box; padding: 1.25rem; margin-bottom: 1rem; border: 1px solid var(--secondary-background-color); border-radius: 14px; transition: border-color 0.15s, box-shadow 0.15s; }
.pf-project:hover { border-color: rgba(94,92,230,0.55); box-shadow: 0 2px 14px rgba(94,92,230,0.12); }
.pf-project .pf-project-img { flex-shrink: 0; width: 88px; height: 88px; object-fit: cover; border-radius: 12px; }
.pf-project .pf-project-body { flex: 1; min-width: 0; }
.pf-project .pf-project-title { margin: 0 0 0.6rem; font-size: 1.15rem; line-height: 1.35; }
.pf-project .pf-tags { display: flex; flex-wrap: wrap; gap: 0.4rem; margin-bottom: 0.75rem; }
.pf-project .pf-badge { -webkit-appearance: none; appearance: none; border: 0; border-radius: 999px; background: var(--secondary-background-color); color: var(--text-color); padding: 0.1rem 0.65rem; font: inherit; font-size: 0.75rem; line-height: 1.6; cursor: pointer; transition: background-color 0.15s, color 0.15s; }
.pf-project .pf-badge:hover { background: #5e5ce6; color: #ffffff; }
.pf-project .pf-project-desc { margin: 0; font-size: 0.95rem; line-height: 1.6; }
.pf-project .pf-project-foot { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.5rem 1rem; margin-top: 1rem; }
.pf-project .pf-project-meta { font-size: 0.8rem; font-style: italic; color: var(--secondary-text-color); }
.pf-project .pf-project-link { display: inline-flex; align-items: center; gap: 0.25rem; padding: 0.3rem 0.85rem; border: 1px solid #5e5ce6; border-bottom: 1px solid #5e5ce6; border-radius: 999px; box-shadow: none; background: transparent; color: #5e5ce6; font-size: 0.85rem; font-weight: 500; text-decoration: none; transition: background-color 0.15s, color 0.15s; }
.pf-project .pf-project-link:hover { background: #5e5ce6; color: #ffffff; box-shadow: none; text-decoration: none; }
.pf-project .pf-project-link svg { width: 14px; height: 14px; fill: currentColor; }
@media (max-width: 600px) { .pf-project { flex-direction: column; gap: 0.75rem; padding: 1rem; } }
</style>

{% assign all_tags = site.data.projects | map: "tags" | join: "," | split: "," | uniq | sort_natural %}

<div class="pf-search">
    <input type="search" id="project-search" class="pf-search-input" placeholder="Search by name, technology, or keyword" aria-label="Search projects" autocomplete="off">
    <div class="pf-filters" role="group" aria-label="Filter by technology">
        <button type="button" class="pf-filter is-active" data-tag="">All</button>
        {% for tag in all_tags %}
        <button type="button" class="pf-filter" data-tag="{{ tag | downcase | escape }}">{{ tag }}</button>
        {% endfor %}
    </div>
    <div class="pf-search-meta">
        <span id="project-count" aria-live="polite">Showing {{ site.data.projects | size }} of {{ site.data.projects | size }} projects</span>
        <button type="button" id="project-reset" class="pf-reset" hidden>Clear filters</button>
    </div>
</div>

<p id="project-empty" class="pf-search-empty" hidden>No projects match your search. Try a different keyword or clear the filters.</p>

{% for project in site.data.projects %}
{% capture haystack %}{{ project.name }} {{ project.description }} {{ project.tags | join: " " }} {{ project.muted }}{% endcapture %}
<div class="pf-project" data-search="{{ haystack | strip_newlines | downcase | escape }}" data-tags="{{ project.tags | join: '|' | downcase | escape }}">
    {% if project.image_url and project.image_url != "" %}
    <img src="{{ project.image_url | relative_url }}" alt="{{ project.name }}" class="pf-project-img" width="88" height="88">
    {% endif %}
    <div class="pf-project-body">
        <h2 class="pf-project-title">{{ project.name }}</h2>
        <div class="pf-tags">
            {% for tag in project.tags %}
            <button type="button" class="pf-badge" data-tag="{{ tag | downcase | escape }}">{{ tag }}</button>
            {% endfor %}
        </div>
        <p class="pf-project-desc">{{ project.description }}</p>
        <div class="pf-project-foot">
            <span class="pf-project-meta">{{ project.muted }}</span>
            {% if project.url_path and project.url_path != "" %}
            <a href="{{ project.url_path | relative_url }}" class="pf-project-link">Read More {% include icons/chevron-right.html %}</a>
            {% endif %}
        </div>
    </div>
</div>
{% endfor %}

<script>
(function () {
  var input = document.getElementById("project-search");
  var cards = Array.prototype.slice.call(document.querySelectorAll(".pf-project"));
  var filters = Array.prototype.slice.call(document.querySelectorAll(".pf-filter"));
  var badges = Array.prototype.slice.call(document.querySelectorAll(".pf-badge"));
  var count = document.getElementById("project-count");
  var empty = document.getElementById("project-empty");
  var reset = document.getElementById("project-reset");
  var total = cards.length;
  var activeTag = "";
  function setTag(tag) {
    activeTag = tag;
    filters.forEach(function (btn) {
      btn.classList.toggle("is-active", btn.getAttribute("data-tag") === tag);
    });
  }
  function apply() {
    var terms = input.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
    var shown = 0;
    cards.forEach(function (card) {
      var haystack = card.getAttribute("data-search");
      var tags = card.getAttribute("data-tags").split("|");
      var matchText = terms.every(function (term) { return haystack.indexOf(term) !== -1; });
      var matchTag = !activeTag || tags.indexOf(activeTag) !== -1;
      var visible = matchText && matchTag;
      card.hidden = !visible;
      if (visible) { shown++; }
    });
    count.textContent = "Showing " + shown + " of " + total + " projects";
    empty.hidden = shown !== 0;
    reset.hidden = !(terms.length || activeTag);
    var params = new URLSearchParams();
    if (input.value.trim()) { params.set("q", input.value.trim()); }
    if (activeTag) { params.set("tag", activeTag); }
    var query = params.toString();
    history.replaceState(null, "", location.pathname + (query ? "?" + query : ""));
  }
  input.addEventListener("input", apply);
  filters.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setTag(btn.getAttribute("data-tag"));
      apply();
    });
  });
  badges.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setTag(btn.getAttribute("data-tag"));
      apply();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  });
  reset.addEventListener("click", function () {
    input.value = "";
    setTag("");
    apply();
    input.focus();
  });
  var params = new URLSearchParams(location.search);
  input.value = params.get("q") || "";
  setTag((params.get("tag") || "").toLowerCase());
  apply();
})();
</script>