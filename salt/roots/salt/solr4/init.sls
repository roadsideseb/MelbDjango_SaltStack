tomcat:
  pkg.installed:
    - name: tomcat6
  service.running:
    - name: tomcat6
    - enabled: True

/etc/solr4/multicore/solr.xml:
  file.managed:
    - source: salt://solr4/solr.xml
    - context:
      core_names: ['prod', 'test', 'stage', 'ci']
    - template: jinja
    - user: tomcat6
    - group: tomcat6
    - require:
      - pkg: tomcat

{% for core_name in ['prod', 'test', 'stage', 'ci'] %}
/etc/solr4/multicore/{{ core_name }}/conf/solrconfig.xml:
  file.managed:
    - source: salt://solr4/solrconfig.xml
    - template: jinja
    - user: tomcat6
    - group: tomcat6
    - require:
      - pkg: tomcat
{% endfor %}

/root/solr-4.2.1.tgz:
  file.managed:
    - source: http://archive.apache.org/dist/lucene/solr/4.2.1/solr-4.2.1.tgz
    - source_hash: md5=e0f1343712fb73379727a15f1088b898
    - unless: test -f /root/solr-4.2.1.tgz
    - stateful: true

unpack-solr-4.2.1:
  cmd.run:
    - name: tar xfv /root/solr-4.2.1.tgz
    - cwd: /root
    - unless: test -d /root/solr-4.2.1
    - require:
      - file: /root/solr-4.2.1.tgz

/etc/solr4/solr.war:
  file.rename:
    - source: /root/solr-4.2.1/example/webapps/solr.war
    - require:
      - cmd: unpack-solr-4.2.1

/etc/tomcat6/Catalina/localhost/solr.xml:
  file.managed:
    - source: salt://solr4/tomcat-solr.xml
    - require:
      - pkg: tomcat
