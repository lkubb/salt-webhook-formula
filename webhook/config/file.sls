# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}

include:
  - {{ sls_package_install }}

Webhook configuration is managed:
  file.serialize:
    - name: {{ webhook.lookup.config }}
    - mode: '0600'
    - user: root
    - group: {{ webhook.lookup.rootgroup }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ webhook.hooks | json }}
    - serializer: json
