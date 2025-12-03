FROM python:3.12-slim

WORKDIR /app

COPY data/data_generator/data_gen_requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

COPY data/data_generator/DataGenerator.py .
COPY data/data_generator/entrypoint.sh .

RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]