#!/bin/bash

python manage.py migrate
# Créer un superutilisateur s'il n'existe pas
echo "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='${DJANGO_SUPERUSER_USERNAME}').exists():
    User.objects.create_superuser(
        '${DJANGO_SUPERUSER_USERNAME}',
        '${DJANGO_SUPERUSER_PASSWORD}'
    )
" | python manage.py shell

exec python manage.py runserver 0.0.0.0:8001
