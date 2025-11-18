import os
from airflow import DAG
from airflow.providers.apache.spark.operators.spark_submit import (
    SparkSubmitOperator,
)
import pendulum
from datetime import timedelta
from textwrap import dedent

table_path = "orders.restaurants"
interval = timedelta(days=1)  # timedelta(minutes=10)
help_scr = "helpers/spark__load_restaurants.py"

# https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html
default_args = {
    "owner": "loader",
    "depends_on_past": False,
    "email_on_failure": False,
    "retries": 1,
    "start_date": pendulum.parse("2025-11-10").in_timezone("UTC"),
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id=f"load_{table_path}",
    default_args=default_args,
    description=f"""
        This DAG fetch data from source_dt (table {table_path})
        and save it to data lake
    """,
    catchup=True,
    schedule=interval,
    tags=["source_db", "minio", table_path],
) as dag:

    fetch_and_load = SparkSubmitOperator(
        task_id=f"load_data_from_table_{table_path}_to_lake",
        application=f"/opt/airflow/dags/{help_scr}",
        conn_id="spark_default",
        application_args=[
            "--url",
            f"jdbc:postgresql://source-db:5432/{os.getenv('SOURCE_DB')}",
            "--db-user",
            os.getenv("SOURCE_DB_USER"),
            "--db-password",
            os.getenv("SOURCE_DB_PASSWORD"),
            "--table-name",
            table_path,
            "--minio-path",
            f"s3a://{os.getenv('MINIO_RAW_BUCKET_NAME')}"
            f"/raw/source/{table_path.replace('.', '/')}",
            "--window_start",
            "{{ data_interval_start"
            ".in_timezone('Europe/Tallinn')"
            ".strftime('%Y-%m-%d %H:%M:%S') }}",
            "--window_end",
            "{{ (data_interval_end if data_interval_end != data_interval_start"
            "   else data_interval_start + dag.schedule"
            ").in_timezone('Europe/Tallinn').strftime('%Y-%m-%d %H:%M:%S') }}",
        ],
        conf={
            "spark.executor.instances": "1",
            "spark.executor.memory": "2g",
            "spark.executor.cores": "1",
            "spark.driver.memory": "1g",
            "spark.hadoop.fs.s3a.endpoint": "http://minio:9000",
            "spark.hadoop.fs.s3a.access.key": os.getenv("MINIO_ROOT_USER"),
            "spark.hadoop.fs.s3a.secret.key": os.getenv("MINIO_ROOT_PASSWORD"),
            "spark.hadoop.fs.s3a.path.style.access": "true",
            "spark.hadoop.fs.s3a.connection.ssl.enabled": "false",
        },
        jars=(
            "/opt/bitnami/spark/jars/postgresql-42.7.8.jar,"
            "/opt/bitnami/spark/jars/hadoop-aws-3.4.1.jar,"
            "/opt/bitnami/spark/jars/bundle-2.37.4.jar,"
            "/opt/bitnami/spark/jars/s3-2.37.4.jar"
        ),
    )

    fetch_and_load.doc_md = dedent(
        f"""\
            #### Fetch and load
            Fetch data from source database ({table_path})
            and load it to MinIO (/source/{table_path.replace('.', '/')})
        """
    )
    dag.doc_md = dedent(
        f"""\
            #### Fetch and load
            Fetch data from source database ({table_path})
            and load it to MinIO (/source/{table_path.replace('.', '/')})
        """
    )

    fetch_and_load
