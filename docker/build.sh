#!/bin/bash
set -e
echo "Building application..."
pwd
ls -l


mvn -B -DskipTests clean package

echo "Building Docker image ${DOCKER_IMAGE}..."
docker build -t $DOCKER_IMAGE .

echo " Image built successfully:"
docker images | grep webgoat || echo "No webgoat image found!"
