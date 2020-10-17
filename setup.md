---
title: Setup
---

## Data

<ol>
{% for data in site.data.dataset %}
  <li>
      {{ data.publisher }}, {{ data.date_published }}. <a href="{{ data.documentation_url }}">"{{ data.name }}"</a>. {{ data.description }}. License: {{ data.license }}.
  </li>
{% endfor %}
</ol>

## Tools 
<ol>
{% for tool in site.data.tool %}
  {% if tool.use == "1" and tool.type == "tool" %}
  <li>
      <a href="{{ tool.documentation_url }}">{{ tool.name }}</a>. {{ tool.purpose }}.
  </li>
  {% endif %}
{% endfor %}
</ol>

## Technologies
<ol>
{% for tool in site.data.tool %}
  {% if tool.use == "1" and tool.type == "technology" %}
  <li>
      <a href="{{ tool.documentation_url }}">{{ tool.name }}</a>. {{ tool.purpose }}.
  </li>
  {% endif %}
{% endfor %}
</ol>

{% include links.md %}
