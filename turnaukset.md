---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Turnaukset
permalink: /tournaments/
---
<h1>Tournaments</h1>

<ul>
{% for tournament_hash in site.data.tournaments %}
{% assign tournament = tournament_hash[1] %}
<li><a href="{{ tournament.title | datapage_url: '/tournaments' }}">{{ tournament.title }}, {{ tournament.date  | date: "%d.%m.%Y" }}</a></li>
{% endfor %}

</ul>