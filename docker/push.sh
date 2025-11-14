#!/bin/bash
set -e

echo "Pushing Docker image to Docker Hub..."

# Verifica si la imagen existe localmente
if ! docker images "${DOCKER_IMAGE}" | grep -q "${DOCKER_IMAGE%%:*}"; then
  echo "❌ ERROR: Docker image ${DOCKER_IMAGE} not found locally!"
  echo "Available images:"
  docker images
  exit 1
fi

# Login a Docker Hub
echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin

# Push con reintentos (evita fallos por timeout de Docker Hub)
MAX_RETRIES=3
COUNT=1

while [ $COUNT -le $MAX_RETRIES ]; do
    echo "➡️ Intento $COUNT de $MAX_RETRIES para hacer push de la imagen..."
    
    if docker push "$DOCKER_IMAGE"; then
        echo "✅ Push realizado correctamente."
        exit 0
    fi

    echo "Fallo en el push (probable timeout de Docker Hub). Reintentando en 5 segundos..."
    sleep 5
    COUNT=$((COUNT+1))
done

echo "❌ ERROR: No se pudo hacer push después de varios intentos."
exit 1
