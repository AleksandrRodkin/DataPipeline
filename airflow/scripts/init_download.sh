WINDOW_END="2025-11-22"

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
    --master spark://spark-master:7077 \
    --deploy-mode client \
    "$SPARK_APP" \
    --url "jdbc:postgresql://source-db:5432/${SOURCE_DB}" \
    --db-user "${SOURCE_DB_USER}" \
    --db-password "${SOURCE_DB_PASSWORD}" \
    --table-name "${TABLE_PATH}" \
    --minio-path "source_${TABLE_PATH}" \
    --window_start "1900-01-01" \
    --window_end "${WINDOW_END}"

  echo "=== Loaded: $TABLE_PATH ==="
  echo
done
