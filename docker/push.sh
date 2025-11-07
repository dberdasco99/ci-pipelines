#!/bin/bash
set -e
echo "Pushing Docker image to Docker Hub..."
echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
docker push $DOCKER_IMAGE
