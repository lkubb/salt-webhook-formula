# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

include:
  - {{ sls_config_file }}

Webhook is running:
  service.running:
    - name: {{ webhook.lookup.service.name }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
