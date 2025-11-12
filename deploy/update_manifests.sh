#!/bin/bash
set -e

# Comprueba que la variable DOCKER_IMAGE esté definida
if [ -z "$DOCKER_IMAGE" ]; then
  echo "❌ Error: la variable DOCKER_IMAGE no está definida"
  exit 1
fi

# Nombre de la aplicación (opcional, por defecto 'webgoat')
APP_NAME=${APP_NAME:-webgoat}

echo "Updating deployment manifests for $APP_NAME with image ${DOCKER_IMAGE}..."

# Limpiamos cualquier clone previo
rm -rf infra-manifests

# Clonamos el repo público de infra-manifests
git clone https://github.com/dberdasco99/infra-manifests infra-manifests

# Verificamos los archivos clonados (opcional, para debug)
echo "Contenido del repo infra-manifests:"
ls -R infra-manifests

# Ruta al manifest de la app
MANIFEST=infra-manifests/${APP_NAME}/deployment.yaml

# Comprobamos que el archivo existe
if [ -f "$MANIFEST" ]; then
    echo "Manifest encontrado: $MANIFEST"
    
    # Reemplazamos el tag de la imagen Docker
    sed -i "s|image: .*|image: ${DOCKER_IMAGE}|g" "$MANIFEST"

    # Commit y push
    git -C infra-manifests add "$MANIFEST"
    git -C infra-manifests commit -m "ci: update ${APP_NAME} image to ${DOCKER_IMAGE}" || echo "No changes to commit"
    git -C infra-manifests push origin main

    echo "✅ Deployment manifest actualizado correctamente"
else
    echo "❌ Manifest no encontrado en $MANIFEST"
    exit 1
fi
