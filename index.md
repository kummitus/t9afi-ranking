---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

<table>
<thead>
    <td>Sija</td>
    <td>Nimi</td>
    <td>Pisteet</td>
</thead>
{% for player in site.data.players %}

    <tr>
        <td>{{ forloop.index }}.</td>
        <td>{{ player.player }}</td>
        <td>{{ player.points }}</td>
    </tr>

{% endfor %}
</table>