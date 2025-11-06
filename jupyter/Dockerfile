FROM python:3.13-slim

COPY jupyter/jupyter_requirements.txt /requirements.txt

RUN apt-get update && apt-get install -y openjdk-21-jdk wget curl

# RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.37.4/bundle-2.37.4.jar
# RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.37.4/s3-2.37.4.jar
# RUN wget -P /opt/bitnami/spark/jars https://jdbc.postgresql.org/download/postgresql-42.7.8.jar
# RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar
# RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j2-impl/2.25.2/log4j-slf4j2-impl-2.25.2.jar

COPY jupyter/dev/jars/ /opt/bitnami/spark/jars

RUN python -m pip install --upgrade pip && \
    pip install -r /requirements.txt

WORKDIR /app