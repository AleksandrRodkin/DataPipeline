FROM postgres:16

ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=pass
ENV POSTGRES_DB=source_db

COPY data/output /data/
COPY data/databases/source_db/init /docker-entrypoint-initdb.d/