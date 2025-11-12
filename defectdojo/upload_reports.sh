#!/bin/bash
set -e

echo "Uploading reports to DefectDojo..."

DD_API="${DEFECTDOJO_API}"
DD_TOKEN="${DEFECTDOJO_TOKEN}"
PROD_NAME="${APP_NAME}"

declare -A SCAN_TYPES=(
  ["gitleaks.json"]="Gitleaks"
  ["semgrep.sarif"]="Semgrep"
  ["dependency-check.xml"]="Dependency Check"
  ["trivy.json"]="Trivy Scan"
)

REPORT_DIR="reports"

if [ ! -d "$REPORT_DIR" ]; then
  echo "❌ Directory $REPORT_DIR does not exist."
  exit 1
fi

for file in "$REPORT_DIR"/*; do
  [ -e "$file" ] || continue
  base=$(basename "$file")
  scan_type=${SCAN_TYPES[$base]:-$base}  # usa el nombre de archivo si no hay mapping
  echo "⬆️ Uploading $scan_type report..."
  curl -k -X POST "${DD_API}/import-scan/" \
    -H "Authorization: Token ${DD_TOKEN}" \
    -F "minimum_severity=Low" \
    -F "scan_type=${scan_type}" \
    -F "file=@${file}" \
    -F "product_name=${PROD_NAME}" \
    -F "engagement_name=CI-${APP_NAME}" \
    -F "lead=CI" || echo "Upload failed for $scan_type"
done
