# --------------------------------------------------------------------
#  Base image
# --------------------------------------------------------------------
FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------------------------
#  System deps
# --------------------------------------------------------------------
RUN apt-get update && apt-get install -y openjdk-21-jdk wget curl ca-certificates procps \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# --------------------------------------------------------------------
#  Install Spark 4.0.1 + Hadoop 3.4.1
# --------------------------------------------------------------------
ENV SPARK_VERSION=4.0.1
ENV HADOOP_VERSION=3.4.1
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"

COPY jupyter-spark/jupyter-spark-config/spark/ /tmp

RUN mkdir -p /opt && \
    if [ -f /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz ]; then \
        echo ">>> Using local Spark archive"; \
        tar -xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt; \
    else \
        echo ">>> Local Spark archive not found, downloading..."; \
        curl -L "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz" \
        -o /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz; \
        tar -xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt; \
    fi && \
    mv "/opt/spark-${SPARK_VERSION}-bin-hadoop3" "$SPARK_HOME" && \
    rm -f /tmp/spark-${SPARK_VERSION}-bin-hadoop3.tgz

# --------------------------------------------------------------------
#  Download required JARs
# --------------------------------------------------------------------
ENV ICEBERG_VERSION=1.10.0
ENV SCALA_VERSION=2.13
ENV POSTGRES_VERSION=42.7.8
ENV DUCKDB_JDBC_VERSION=1.0.0
ENV AWS_SDK_VERSION=2.37.4

RUN wget -q -O ${SPARK_HOME}/jars/iceberg-spark-runtime.jar \
      "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_VERSION%.*}_${SCALA_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_VERSION%.*}_${SCALA_VERSION}-${ICEBERG_VERSION}.jar" \
 && wget -q -O ${SPARK_HOME}/jars/postgresql.jar \
      "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar" \
 && wget -q -O ${SPARK_HOME}/jars/duckdb_jdbc.jar \
      "https://repo1.maven.org/maven2/org/duckdb/duckdb_jdbc/${DUCKDB_JDBC_VERSION}/duckdb_jdbc-${DUCKDB_JDBC_VERSION}.jar" \
 && wget -q -O ${SPARK_HOME}/jars/hadoop-aws.jar \
      "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar" \
 && wget -q -O ${SPARK_HOME}/jars/bundle.jar \
      "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar" \
 && wget -q -O ${SPARK_HOME}/jars/s3.jar \
      "https://repo1.maven.org/maven2/software/amazon/awssdk/s3/${AWS_SDK_VERSION}/s3-${AWS_SDK_VERSION}.jar"

# --------------------------------------------------------------------
#  Install Python libs
# --------------------------------------------------------------------

RUN python -m pip install pyspark==${SPARK_VERSION}
RUN python -m pip install jupyterlab==4.4.10
RUN python -m pip install pandas==2.3.3
RUN python -m pip install pyarrow==22.0.0
RUN python -m pip install duckdb==1.4.2

# --------------------------------------------------------------------
#  Spark config
# --------------------------------------------------------------------
COPY jupyter-spark/jupyter-spark-config/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

# --------------------------------------------------------------------
#  Jupyter config
# --------------------------------------------------------------------
EXPOSE 8888 4040

WORKDIR /workspace