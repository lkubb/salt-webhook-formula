# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as webhook with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

{%- if webhook.install_method == "pkg" %}

Webhook is installed:
  pkg.installed:
    - name: {{ webhook.lookup.pkg.name }}

{%-   if "systemd" | which and webhook.service_hardened %}

Webhook hardened service unit is installed:
  file.managed:
    - name: /etc/systemd/system/{{ webhook.lookup.service.name }}.service.d/harden.conf
    - source: {{ files_switch(
                    ["webhook_override.service", "webhook_override.service.j2"],
                    config=webhook,
                    lookup="Webhook hardened service unit is installed"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ webhook.lookup.rootgroup }}
    - makedirs: true
    - require:
      - pkg: {{ webhook.lookup.pkg.name }}
{%-   endif %}
{%- else %}

Golang is installed for Webhook:
  pkg.installed:
    - name: {{ webhook.lookup.pkg.golang }}

Webhook build user is present:
  user.present:
    - name: {{ webhook.lookup.build_user.name }}
    - home: {{ webhook.lookup.build_user.home }}
    - createhome: true

Webhook is cloned:
  file.directory:
    - name: {{ webhook.lookup.paths.build }}
    - makedirs: true
    - user: {{ webhook.lookup.build_user.name }}
    - mode: '0755'
  git.latest:
    - name: {{ webhook.lookup.repo }}
    - target: {{ webhook.lookup.paths.build }}
{%-   if webhook.rev %}
    - rev: {{ webhook.rev | json }}
{%-   endif %}
    - user: {{ webhook.lookup.build_user.name }}
    - force_reset: true
    - require:
      - file: {{ webhook.lookup.paths.build }}
      - pkg: {{ webhook.lookup.pkg.golang }}
      - user: {{ webhook.lookup.build_user.name }}

Webhook is installed:
  file.directory:
    - name: {{ salt["file.dirname"](webhook.lookup.paths.bin) }}
  cmd.run:
    - name: go build -o '{{ webhook.lookup.paths.bin }}'
    - cwd: {{ webhook.lookup.paths.build }}
    - runas: {{ webhook.lookup.build_user.name }}
    - require:
      - file: {{ salt["file.dirname"](webhook.lookup.paths.bin) }}
    - onchanges:
      - git: {{ webhook.lookup.repo }}

Webhook service unit is installed:
  file.managed:
    - name: {{ webhook.lookup.service.unit.format(name=webhook.lookup.service.name) }}
    - source: {{ files_switch(
                    ["webhook.service", "webhook.service.j2"],
                    config=webhook,
                    lookup="Webhook service unit is installed",
                  )
              }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ webhook.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"webhook": webhook} | json }}
    - require:
      - Webhook is installed
{%- endif %}
