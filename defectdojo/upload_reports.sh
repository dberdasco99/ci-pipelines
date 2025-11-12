#!/bin/bash
set -e
echo "Uploading reports to DefectDojo..."

API_URL="${DEFECTDOJO_API}/api/v2/import-scan/"
TOKEN="${DEFECTDOJO_TOKEN}"
PRODUCT_NAME="${APP_NAME:-webgoat}"  # fallback si está vacío

for report in reports/*.json; do
  report_name=$(basename "$report")
  echo "⬆️ Uploading $report_name report..."
  
  response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL" \
    -H "Authorization: Token $TOKEN" \
    -F "scan_type=Generic Findings Import" \
    -F "file=@$report" \
    -F "product_name=$PRODUCT_NAME")
  
  if [[ "$response" == "201" ]]; then
    echo "✅ Uploaded $report_name successfully"
  else
    echo "❌ Upload failed for $report_name (HTTP $response)"
  fi
done
