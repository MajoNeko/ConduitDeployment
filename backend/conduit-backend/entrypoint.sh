#!/bin/sh
set -e

echo "Waiting for postgres..."
until python -c "
import os, sys, psycopg2
try:
    psycopg2.connect(
        dbname=os.environ['DB_NAME'], 
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        host=os.environ['DB_HOST'],
        port=os.environ.get('DB_PORT', '5432'),
    )
except psycopg2.OperationalError:
    sys.exit(1)
"; do
  echo "Postgres unavailable, retrying in 2s..."
  sleep 2
done
echo "Postgres is up."

echo "Applying migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting gunicorn..."
exec "$@"