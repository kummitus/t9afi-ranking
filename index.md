---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
---
<h2>Uudet turnaukset</h2>
<ul>
  {% for post in site.categories["turnaukset"] %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}, {{ post.date | date: "%d.%m.%Y" }}</a>
    </li>
    {% if forloop.index == 2 %}
        {% break %}
    {% endif %}
  {% endfor %}
</ul>

<hr>
<br>
<h2>Ranking</h2>

<table>
<thead>
    <td>Sija</td>
    <td>Nimi</td>
    <td>Rankingisteet</td>
</thead>
{% for player in site.data.players %}

    <tr>
        <td>{{ forloop.index }}.</td>
        <td><a href="{{ player.player | datapage_url: '/players' }}">{{ player.player }}</a></td>
        <td>{{ player.points | round }}</td>
    </tr>

{% endfor %}
</table>