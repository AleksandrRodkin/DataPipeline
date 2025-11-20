FROM python:3.12-slim

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

COPY dbt/dbt_requirements.txt /requirements.txt

RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r /requirements.txt

ENV DBT_PROFILES_DIR=/usr/app/dbt/dbt_pipeline/profiles