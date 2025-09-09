#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

check_deps
YEAR="${1:-${YEAR}}"
OUT_RAW="${DATA_DIR}/${YEAR}/raw"
OUT_CSV="${DATA_DIR}/${YEAR}/csv"
mkdir -p "${OUT_RAW}" "${OUT_CSV}"

banner "🏁 ${YEAR} 시즌 스탠딩 수집"

run_with_spinner "드라이버 스탠딩 다운로드" \
  curl -s "${BASE}/${YEAR}/driverStandings.json" -o "${OUT_RAW}/driverStandings.json"

run_with_spinner "컨스트럭터 스탠딩 다운로드" \
  curl -s "${BASE}/${YEAR}/constructorStandings.json" -o "${OUT_RAW}/constructorStandings.json"

run_with_spinner "드라이버 스탠딩 CSV 생성" \
  bash -c "
    jq -r \"${driver_standings_filter} | [ .pos, .driver, .constructor, .points, .wins ] | @csv\" \
      '${OUT_RAW}/driverStandings.json' > '${OUT_CSV}/driver_standings.csv'
  "

run_with_spinner "컨스트럭터 스탠딩 CSV 생성" \
  bash -c "
    jq -r \"${constructor_standings_filter} | [ .pos, .constructor, .points, .wins ] | @csv\" \
      '${OUT_RAW}/constructorStandings.json' > '${OUT_CSV}/constructor_standings.csv'
  "

f1_car_animation 60 1
echo -e "\033[1;32mCSV 저장:\033[0m ${OUT_CSV}/driver_standings.csv, ${OUT_CSV}/constructor_standings.csv"
