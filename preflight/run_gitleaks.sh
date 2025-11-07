#!/bin/bash
set -e
echo "Haciendo Gitleaks secret scanning..."
gitleaks detect --source . --report-format json --report-path reports/${APP_NAME}-gitleaks.json || true
