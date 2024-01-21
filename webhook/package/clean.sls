# vim: ft=sls

{#-
    Removes the webhook package and hardened service unit, if installed.
    Has a dependency on `webhook.config.clean`_.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

include:
  - {{ sls_config_clean }}

{%- if webhook.install_method == "pkg" %}
{%-   if "systemd" | which and webhook.service_hardened %}

Webhook hardened service unit is removed:
  file.absent:
    - name: /etc/systemd/system/{{ webhook.lookup.service.name }}.service.d/harden.conf
{%-   endif %}

Webhook is removed:
  pkg.removed:
    - name: {{ webhook.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
{%- else %}

Webhook is removed:
  user.absent:
    - name: {{ webhook.lookup.build_user.name }}
    - purge: true
    - require:
      - sls: {{ sls_config_clean }}
  file.absent:
    - names:
      - {{ webhook.lookup.paths.build }}
      - {{ webhook.lookup.paths.bin }}
      - {{ webhook.lookup.service.unit.format(name=webhook.lookup.service.name) }}
    - require:
      - sls: {{ sls_config_clean }}
{%- endif %}
