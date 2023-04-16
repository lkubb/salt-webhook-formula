# vim: ft=sls

{#-
    Removes the webhook package and hardened service unit, if installed.
    Has a depency on `webhook.config.clean`_.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

include:
  - {{ sls_config_clean }}

{%- if "systemd" | which and webhook.service_hardened %}

Webhook hardened service unit is removed:
  file.absent:
    - name: /etc/systemd/system/{{ webhook.lookup.service.name }}.service.d/harden.conf
{%- endif %}

Webhook is removed:
  pkg.removed:
    - name: {{ webhook.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
