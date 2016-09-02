FROM jetty

COPY target/clickCount.war /var/lib/jetty/webapps/
