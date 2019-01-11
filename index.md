---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

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