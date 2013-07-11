
redis:
  pkg.installed:
    - name: redis-server
  service.running:
    - name: redis-server
    - enable: True
    - require:
      - pkg: redis

/etc/redis/redis.conf:
  file.comment:
    - regex: ^bind 127.0.0.1
    - require:
      - pkg: redis
