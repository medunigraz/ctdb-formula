{% from "ctdb/map.jinja" import ctdb with context %}

ctdb_packages:
  pkg.installed:
    - names: {{ ctdb.pkgs }}

{{ ctdb.files.config }}:
  file.managed:
    - source: salt://ctdb/files/ctdbd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ctdb_packages

{{ ctdb.files.nodes }}:
  file.managed:
    - source: salt://ctdb/files/nodes
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ctdb_packages

{%- if ctdb.get('manage_public', False) %}
{{ ctdb.files.public_addresses }}:
  file.managed:
    - source: salt://ctdb/files/public_addresses
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ctdb_packages
    - watch_in:
      - service: ctdb_services
    - require_in:
      - service: ctdb_services
{%- endif %}

ctdb_services:
  service.running:
    - names: {{ ctdb.services }}
    - enable: True
    - watch:
      - file: {{ ctdb.files.config }}
      - file: {{ ctdb.files.nodes }}
    - require:
      - pkg: ctdb
      - file: {{ ctdb.files.config }}
      - file: {{ ctdb.files.nodes }}
