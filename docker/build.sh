#!/bin/bash
set -e
echo "uilding application..."
mvn -B -DskipTests clean package

echo "Building Docker image ${DOCKER_IMAGE}..."
docker build -t $DOCKER_IMAGE .
