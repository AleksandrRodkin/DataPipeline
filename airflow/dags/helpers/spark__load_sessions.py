from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_date
import argparse

from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    IntegerType,
    TimestampType,
    DateType,
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

ts_col = "started_at"

spark = SparkSession.builder.appName("LoadToLake").getOrCreate()

try:

    schema = StructType(
        [
            StructField("id", StringType(), False),
            StructField("user_id", StringType(), False),
            StructField("started_at", TimestampType(), False),
            StructField("ended_at", TimestampType(), True),
            StructField("actions", IntegerType(), True),
            StructField("platform", StringType(), True),
            StructField("date", DateType(), False),
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

    df = df.withColumn("date", to_date(col(ts_col)))

    df = spark.createDataFrame(df.rdd, schema)

    print(
        f"Start timestamp '{args.window_start}'"
        f" AND End timestamp '{args.window_end}'"
    )
    print("Count=", df.count())

    df.repartition(10).writeTo(f"datalake.{args.minio_path}").partitionedBy(
        "date"
    ).createOrReplace()

finally:
    spark.stop()
