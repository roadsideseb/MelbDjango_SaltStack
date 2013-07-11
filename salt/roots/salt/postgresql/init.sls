postgresql:
  pkg.installed:
    - name: postgresql-9.1
  service.running:
    - require:
      - pkg: postgresql
    - watch:
      - file: /etc/postgresql/9.1/main/pg_hba.conf


/etc/postgresql/9.1/main/pg_hba.conf:
  file.managed:
    - source: salt://postgresql/pg_hba.conf
    - require:
      - pkg: postgresql


/etc/postgresql/9.1/main/postgresql.conf:
  file.managed:
    - source: salt://postgresql/postgresql.conf
    - require:
      - pkg: postgresql


{% for name in pillar['database']['prefixes'] %}
{{ name }}_app:
  postgres_user.present:
    - createdb: True
    - createuser: False
    - superuser: False
    - runas: postgres
    - password: {{ name }}password
{% endfor %}
