---
layout: page
title: Projects
permalink: /projects/
---

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
            <a href="{{ project.url_path | relative_url }}" class="pf-project-link">
              Read More {% include icons/chevron-right.html %}
            </a>
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