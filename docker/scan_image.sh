#!/bin/bash
set -e
echo "Escaneo de Docker image con Trivy..."
mkdir -p reports
trivy image --format json -o reports/${APP_NAME}-trivy.json $DOCKER_IMAGE || true
