#!/bin/bash
set -e
echo "OWASP Dependency-Check..."

# Ejecuta desde donde lo instalaste
DC_PATH="$(pwd)/dependency-check/bin/dependency-check.sh"

# Si no existe, intenta usar el sistema (por si el symlink sí funcionó)
if [ ! -f "$DC_PATH" ]; then
  DC_PATH="$(which dependency-check.sh || true)"
fi

if [ -x "$DC_PATH" ]; then
  "$DC_PATH" --project "${APP_NAME}" --scan ./app \
    --format XML --out reports/dependency-check-report.xml || true
else
  echo "❌ No se encontró dependency-check.sh en $DC_PATH"
  exit 1
fi

# Renombra el reporte para DefectDojo
mv reports/dependency-check-report.xml "reports/${APP_NAME}-dependency-check-report.xml" || true
