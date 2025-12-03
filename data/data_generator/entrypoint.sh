#!/bin/sh
set -e

DATA_DIR=/data

for f in couriers.csv orders.csv promos.csv restaurants.csv sessions.csv users.csv; do
  if [ ! -f "$DATA_DIR/$f" ]; then
    echo "Missing files. Regenerating data..."
    rm -f "$DATA_DIR"/*
    python DataGenerator.py --output-dir "$DATA_DIR"
    exit 0
  fi
done

echo "All files exist. Nothing to do"