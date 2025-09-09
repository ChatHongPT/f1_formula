#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

YEAR="${1:-${YEAR}}"
validate_year "$YEAR"

banner "🚦 Initialize directories for season ${YEAR}"
run_with_spinner "디렉토리 생성" bash -c "
  mkdir -p '${DATA_DIR}/${YEAR}/raw' '${DATA_DIR}/${YEAR}/csv' '${DATA_DIR}/${YEAR}/rounds'
"
f1_car_animation 50 1
echo -e "\033[1;32m완료: ${DATA_DIR}/${YEAR}/\033[0m"
