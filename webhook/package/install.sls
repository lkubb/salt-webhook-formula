# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

webhook-package-install-pkg-installed:
  pkg.installed:
    - name: {{ webhook.lookup.pkg.name }}

{%- if "systemd" | which and webhook.service_hardened %}

Webhook hardened service unit is installed:
  file.managed:
    - name: /etc/systemd/system/{{ webhook.lookup.service.name }}.service.d/harden.conf
    - source: {{ files_switch(['webhook.service', 'webhook.service.j2'],
                              lookup='Webhook hardened service unit is installed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ webhook.lookup.rootgroup }}
    - makedirs: True
    - require:
      - pkg: {{ webhook.lookup.pkg.name }}
{%- endif %}
