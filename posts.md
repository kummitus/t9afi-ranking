---
layout: page
title: Uutiset
permalink: /news/
---

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}, {{ post.date | date: "%d.%m.%Y" }}</a>
    </li>
  {% endfor %}
</ul>