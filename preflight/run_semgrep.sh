#!/bin/bash
set -e

echo "Haciendo Semgrep SAST..."

# Crear y activar virtualenv
python3 -m venv .venv
source .venv/bin/activate

# Actualizar pip e instalar semgrep
pip install --upgrade pip
pip install semgrep

# Ejecutar semgrep
semgrep --config auto --json --output reports/${APP_NAME}-semgrep.json || true

# Desactivar virtualenv
deactivate
