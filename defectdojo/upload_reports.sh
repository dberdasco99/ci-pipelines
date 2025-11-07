#!/bin/bash
set -e
echo "ploading reports to DefectDojo..."

DD_API="${DEFECTDOJO_API}"
DD_TOKEN="${DEFECTDOJO_TOKEN}"
PROD_NAME="${APP_NAME}"

declare -A SCAN_TYPES=(
  ["gitleaks"]="Gitleaks"
  ["semgrep"]="Semgrep"
  ["dependency-check"]="Dependency Check"
  ["trivy"]="Trivy Scan"
)

for file in reports/${APP_NAME}-*; do
  base=$(basename "$file")
  tool=$(echo "$base" | cut -d'-' -f2 | cut -d'.' -f1)
  scan_type=${SCAN_TYPES[$tool]}
  echo "⬆️ Uploading $tool report..."
  curl -k -X POST "${DD_API}/import-scan/" \
    -H "Authorization: Token ${DD_TOKEN}" \
    -F "minimum_severity=Low" \
    -F "scan_type=${scan_type}" \
    -F "file=@${file}" \
    -F "product_name=${PROD_NAME}" \
    -F "engagement_name=CI-${APP_NAME}" \
    -F "lead=CI" || echo "pload failed for $tool"
done
