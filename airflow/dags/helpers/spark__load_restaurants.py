from pyspark.sql import SparkSession

# from pyspark.sql.functions import col, to_date
import argparse
from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    FloatType,
    BooleanType,
    TimestampType,
)

parser = argparse.ArgumentParser()
parser.add_argument("--url", required=True)
parser.add_argument("--db-user", required=True)
parser.add_argument("--db-password", required=True)
parser.add_argument("--table-name", required=True)
parser.add_argument("--minio-path", required=True)
parser.add_argument("--window_start", required=True)
parser.add_argument("--window_end", required=True)
args = parser.parse_args()

ts_col = "modified_at"

spark = SparkSession.builder.appName("LoadToLake").getOrCreate()

try:

    schema = StructType(
        [
            StructField("id", StringType(), False),
            StructField("name", StringType(), False),
            StructField("city", StringType(), True),
            StructField("cuisine_type", StringType(), True),
            StructField("rating", FloatType(), True),
            StructField("work_start_time", StringType(), True),
            StructField("work_end_time", StringType(), True),
            StructField("is_24h", BooleanType(), True),
            StructField("modified_at", TimestampType(), True),
        ]
    )

    df = (
        spark.read.format("jdbc")
        .option("url", args.url)
        .option("user", args.db_user)
        .option("password", args.db_password)
        .option("dbtable", args.table_name)
        .option("fetchsize", 1000)
        .option("driver", "org.postgresql.Driver")
        .option("pushDownPredicate", "true")
        .load()
        .filter(
            f"""
                {ts_col} >= timestamp '{args.window_start}'
                AND {ts_col} < timestamp '{args.window_end}'
            """
        )
    )

    df = spark.createDataFrame(df.rdd, schema)

    print(
        f"Start timestamp '{args.window_start}'"
        f" AND End timestamp '{args.window_end}'"
    )
    print("Count=", df.count())

    df.repartition(10).writeTo(f"datalake.{args.minio_path}").partitionedBy(
        "city"
    ).createOrReplace()

finally:
    spark.stop()
