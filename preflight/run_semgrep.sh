#!/bin/bash
set -e
echo "Haciendo Semgrep SAST..."
semgrep --config auto --json --output reports/${APP_NAME}-semgrep.json || true
