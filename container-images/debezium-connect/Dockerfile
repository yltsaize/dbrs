ARG DEBEZIUM_VERSION
FROM quay.io/debezium/connect:${DEBEZIUM_VERSION}

# confluent-hub
RUN cd /kafka && \
    curl -sLo confluent-hub.tar.gz http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz && \
    tar -zxf confluent-hub.tar.gz && \
    rm confluent-hub.tar.gz

# Extra connectors
RUN /kafka/bin/confluent-hub install --no-prompt --component-dir=/kafka/connect \
    --worker-configs=/kafka/config.orig/connect-distributed.properties \
    confluentinc/kafka-connect-jdbc:10.6.0

# JDBC driver
RUN curl -so /kafka/libs/mysql-connector-java-8.0.30.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar \
    && curl -so /kafka/libs/ojdbc8-21.6.0.0.jar https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.6.0.0/ojdbc8-21.6.0.0.jar

# Following debezium/connect Dockerfile spec to enable JMX exporter:
# https://github.com/debezium/container-images/blob/main/connect-base/2.2/docker-entrypoint.sh#L193
ENV ENABLE_JMX_EXPORTER=true
ARG JMX_AGENT_VERSION
RUN cd $KAFKA_HOME/libs && \
    curl -so jmx_prometheus_javaagent.jar \
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_AGENT_VERSION/jmx_prometheus_javaagent-$JMX_AGENT_VERSION.jar
COPY metrics.yaml /kafka/config/metrics.yaml
