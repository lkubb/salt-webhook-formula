# vim: ft=sls

{#-
    Stops the webhook service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

Webhook is dead:
  service.dead:
    - name: {{ webhook.lookup.service.name }}
    - enable: false
