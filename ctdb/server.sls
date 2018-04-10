{% from "ctdb/map.jinja" import ctdb with context %}

ctdb_packages:
  pkg.installed:
    - name: {{ ctdb.pkgs }}

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

{{ ctdb.files.public_addresses }}:
  file.managed:
    - source: salt://ctdb/files/public_addresses
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ctdb_packages

ctdb_services:
  service.running:
    - name: {{ ctdb.services }}
    - enable: True
    - watch:
      - file: {{ ctdb.files.config }}
      - file: {{ ctdb.files.nodes }}
      - file: {{ ctdb.files.public_addresses }}
    - require:
      - pkg: ctdb
      - file: {{ ctdb.files.config }}
      - file: {{ ctdb.files.nodes }}
      - file: {{ ctdb.files.public_addresses }}
