# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

webhook-service-clean-service-dead:
  service.dead:
    - name: {{ webhook.lookup.service.name }}
    - enable: False
