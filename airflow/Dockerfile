FROM apache/airflow:3.1.1

COPY airflow/airflow_requirements.txt /requirements.txt

RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r /requirements.txt