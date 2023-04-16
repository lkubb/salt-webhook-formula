# vim: ft=sls

{#-
    Removes the configuration of the webhook service and has a
    dependency on `webhook.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

include:
  - {{ sls_service_clean }}

Webhook configuration is absent:
  file.absent:
    - name: {{ webhook.lookup.config }}
    - require:
      - sls: {{ sls_service_clean }}
