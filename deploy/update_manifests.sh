#!/bin/bash
set -e

# Comprobamos variables necesarias
if [ -z "$DOCKER_IMAGE" ]; then
  echo "❌ Error: DOCKER_IMAGE no definido"
  exit 1
fi
if [ -z "$GITHUB_TOKEN_MANIFESTS" ]; then
  echo "❌ Error: GITHUB_TOKEN_MANIFESTS no definido"
  exit 1
fi

APP_NAME=${APP_NAME:-webgoat}

echo "Updating deployment manifests for $APP_NAME with image ${DOCKER_IMAGE}..."

# Limpiamos cualquier clone previo
rm -rf infra-manifests

# Clonamos usando token para poder hacer push
git clone https://${GITHUB_TOKEN_MANIFESTS}@github.com/dberdasco99/infra-manifests infra-manifests

# Verificamos los archivos clonados (opcional, para debug)
echo "Contenido del repo infra-manifests:"
ls -R infra-manifests

# Ruta relativa al manifest dentro del repo
MANIFEST=${APP_NAME}/deployment.yaml

# Comprobamos que existe
if [ -f "infra-manifests/$MANIFEST" ]; then
    echo "Manifest encontrado: infra-manifests/$MANIFEST"

    # Reemplazamos tag de la imagen Docker
    sed -i "s|image: .*|image: ${DOCKER_IMAGE}|g" "infra-manifests/$MANIFEST"

    # Commit y push desde el repo clonado
    cd infra-manifests
    git add "$MANIFEST"
    git commit -m "ci: update ${APP_NAME} image to ${DOCKER_IMAGE}" || echo "No changes to commit"
    git push origin main

    echo "✅ Deployment manifest actualizado correctamente"
else
    echo "❌ Manifest no encontrado: infra-manifests/$MANIFEST"
    exit 1
fi
