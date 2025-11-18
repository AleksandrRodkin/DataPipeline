WINDOW_END="2025-11-10"

SPARK_APPS=(
  "/opt/airflow/dags/helpers/spark__load_users.py"
  "/opt/airflow/dags/helpers/spark__load_sessions.py"
  "/opt/airflow/dags/helpers/spark__load_restaurants.py"
  "/opt/airflow/dags/helpers/spark__load_couriers.py"
  "/opt/airflow/dags/helpers/spark__load_promos.py"
  "/opt/airflow/dags/helpers/spark__load_orders.py"
)

TABLE_PATHS=(
  "app.users"
  "app.sessions"
  "orders.restaurants"
  "orders.couriers"
  "marketing.promos"
  "orders.orders"
)

for i in "${!SPARK_APPS[@]}"; do
  SPARK_APP="${SPARK_APPS[$i]}"
  TABLE_PATH="${TABLE_PATHS[$i]}"

  echo "=== Start loading: $TABLE_PATH ==="

  spark-submit \
    --master local \
    --conf spark.executor.instances=1 \
    --conf spark.executor.memory=2g \
    --conf spark.executor.cores=1 \
    --conf spark.driver.memory=1g \
    --conf spark.hadoop.fs.s3a.endpoint=http://minio:9000 \
    --conf spark.hadoop.fs.s3a.access.key="${MINIO_ROOT_USER}" \
    --conf spark.hadoop.fs.s3a.secret.key="${MINIO_ROOT_PASSWORD}" \
    --conf spark.hadoop.fs.s3a.path.style.access=true \
    --conf spark.hadoop.fs.s3a.connection.ssl.enabled=false \
    --conf spark.hadoop.fs.s3.=org.apache.hadoop.fs.s3a.S3AFileSystem \
    --conf spark.hadoop.fs.s3.impl.disable.cache=true \
    --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}=org.apache.iceberg.spark.SparkCatalog \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}.catalog-impl=org.apache.iceberg.rest.RESTCatalog \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}.uri=http://rest:8181 \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}.s3.endpoint=http://minio:9000 \
    --conf spark.sql.catalog.${MINIO_RAW_BUCKET_NAME}.s3.path-style-access=true \
    --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem
    --jars "/opt/bitnami/spark/jars/postgresql-42.7.8.jar,/opt/bitnami/spark/jars/hadoop-aws-3.4.1.jar,/opt/bitnami/spark/jars/bundle-2.37.4.jar,/opt/bitnami/spark/jars/s3-2.37.4.jar" \
    "$SPARK_APP" \
    --url "jdbc:postgresql://source-db:5432/${SOURCE_DB}" \
    --db-user "${SOURCE_DB_USER}" \
    --db-password "${SOURCE_DB_PASSWORD}" \
    --table-name "${TABLE_PATH}" \
    --minio-path "${MINIO_RAW_BUCKET_NAME}/raw/source/${TABLE_PATH//./\/}" \
    --window_start "1900-01-01" \
    --window_end "${WINDOW_END}"

  echo "=== Loaded: $TABLE_PATH ==="
  echo
done
