#!/bin/bash

echo "⏳ Waiting for DB to be ready..."
sleep 5

echo "🚀 Applying migrations..."
python manage.py migrate

echo "👤 Creating superuser if it doesn't exist..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
from django.db import OperationalError
import time

User = get_user_model()
for i in range(5):
    try:
        if not User.objects.filter(username="${DJANGO_SUPERUSER_USERNAME}").exists():
            User.objects.create_superuser(
                username="${DJANGO_SUPERUSER_USERNAME}",
                password="${DJANGO_SUPERUSER_PASSWORD}"
            )
        break
    except OperationalError as e:
        print(f"Database not ready, retrying... {e}")
        time.sleep(2)
EOF

echo "🚦 Starting server..."
exec python manage.py runserver 0.0.0.0:8001
