#!/bin/bash
set -e
echo "OWASP Dependency-Check..."
dependency-check.sh --scan . --format XML --out reports/ || true
mv reports/dependency-check-report.xml reports/${APP_NAME}-dependency-check.xml || true
