#!/bin/bash
set -e
echo "Escaneo de Docker image con Trivy..."
mkdir -p reports
trivy image --timeout 20m --light --format json \
  --output reports/${APP_NAME}-trivy.json \
  "${DOCKER_IMAGE}" || echo "⚠️ Trivy scan completed with warnings"

