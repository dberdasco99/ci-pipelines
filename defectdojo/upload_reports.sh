#!/bin/bash
set -e
echo "Uploading reports to DefectDojo..."

API_URL="${DEFECTDOJO_API}/api/v2/import-scan/"
TOKEN="${DEFECTDOJO_TOKEN}"
PRODUCT_NAME="${APP_NAME:-webgoat}"

for report in reports/*.json; do
  report_name=$(basename "$report")
  echo "⬆️ Uploading $report_name report..."
  
  if [[ ! -f "$report" ]]; then
    echo "❌ Report file not found: $report"
    continue
  fi

  echo "DEBUG → API_URL: $API_URL"
  echo "DEBUG → PRODUCT_NAME: $PRODUCT_NAME"
  echo "DEBUG → Uploading file: $report"

  response=$(curl -s -o response.log -w "%{http_code}" -X POST "$API_URL" \
    -H "Authorization: Token $TOKEN" \
    -F "scan_type=Generic Findings Import" \
    -F "file=@$report" \
    -F "product_name=$PRODUCT_NAME")

  echo "HTTP response code: $response"
  cat response.log || true

  if [[ "$response" == "201" ]]; then
    echo "✅ Uploaded $report_name successfully"
  else
    echo "❌ Upload failed for $report_name (HTTP $response)"
  fi
done
