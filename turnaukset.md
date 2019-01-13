---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Turnaukset
permalink: /tournaments/
---
<ol class="list">
{% for tournament_hash in site.data.tournaments %}
{% assign tournament = tournament_hash[1] %}
<li id="{{ tournament.date }}"><a href="{{ tournament.title | datapage_url: '/tournaments' }}">{{ tournament.title }}, {{ tournament.date  | date: "%d.%m.%Y" }}</a></li>
{% endfor %}

</ol>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
function sortList(selector) {
    $(selector).find("li").sort(function(a, b) {
        return(Date.parse(b.id) - Date.parse(a.id));
    }).each(function(index, el) {
        $(el).parent().append(el);
    });
}

sortList(".list");
</script>