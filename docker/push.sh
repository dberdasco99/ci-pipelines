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

echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
docker push $DOCKER_IMAGE
