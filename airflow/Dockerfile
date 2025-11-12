FROM apache/airflow:3.1.1

USER root

RUN apt-get update && apt-get install -y openjdk-17-jdk wget curl

RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.37.4/bundle-2.37.4.jar
RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.37.4/s3-2.37.4.jar
RUN wget -P /opt/bitnami/spark/jars https://jdbc.postgresql.org/download/postgresql-42.7.8.jar
RUN wget -P /opt/bitnami/spark/jars https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar

COPY airflow/airflow_requirements.txt /requirements.txt

USER airflow

RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r /requirements.txt