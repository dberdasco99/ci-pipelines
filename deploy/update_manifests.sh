#!/bin/bash
set -e

echo "Updating deployment manifests for ${DOCKER_IMAGE}..."

# Limpiamos cualquier clone previo
rm -rf infra-manifests

# Clonamos el repo (público, sin token)
git clone https://github.com/dberdasco99/infra-manifests infra-manifests

# Ruta del manifest de WebGoat
MANIFEST=infra-manifests/webgoat/deployment.yaml

if [ -f "$MANIFEST" ]; then
    # Reemplazamos el tag de la imagen Docker
    sed -i "s|image: .*|image: ${DOCKER_IMAGE}|g" "$MANIFEST"

    # Commit y push
    git -C infra-manifests add "$MANIFEST"
    git -C infra-manifests commit -m "ci: update WebGoat image to ${DOCKER_IMAGE}" || echo "No changes to commit"
    git -C infra-manifests push origin main
else
    echo "❌ Manifest no encontrado: $MANIFEST"
fi
