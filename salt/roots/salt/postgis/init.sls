postgis-packages:
  pkg.installed:
    - names:
      - postgis
      - postgresql-9.1-postgis


postgis-template:
  file.managed:
    - name: /etc/postgresql/9.1/main/postgis_template.sh
    - source: salt://postgis/create_template_postgis.sh
    - user: postgres
    - group: postgres
    - mode: 755
  cmd.run:
    - name: bash /etc/postgresql/9.1/main/postgis_template.sh
    - user: postgres
    - cwd: /var/lib/postgresql
    - unless: psql -U postgres -l|grep template_postgis
    - require:
      - file: postgis-template
      - pkg: postgis-packages


{% for name in pillar['database']['prefixes'] %}
{{ name }}_db:
  cmd.run:
    - name: createdb -E UTF8 -T template_postgis -U postgres {{ name }}_db
    - user: postgres
    - unless: psql -U postgres -ltA | grep '^{{ name }}_db|'
    - require:
      - cmd: postgis-template
{% endfor %}
