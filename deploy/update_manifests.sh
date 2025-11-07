#!/bin/bash
set -e
echo "Updating deployment manifests for ${APP_NAME}..."

git clone https://github.com/${INFRA_MANIFESTS_REPO} infra-manifests
MANIFEST="infra-manifests/k8s/${APP_NAME}-deployment.yaml"

if [ -f "$MANIFEST" ]; then
  sed -i "s|image: .*|image: ${DOCKER_IMAGE}|g" "$MANIFEST"
  cd infra-manifests
  git config user.name "github-actions"
  git config user.email "actions@github.com"
  git add "$MANIFEST"
  git commit -m "ci: update image for ${APP_NAME} to ${GITHUB_SHA}" || true
  git push https://x-access-token:${MANIFESTS_REPO_TOKEN}@github.com/${INFRA_MANIFESTS_REPO}.git main
else
  echo "anifest not found: $MANIFEST"
fi
