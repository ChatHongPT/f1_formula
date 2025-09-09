#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

check_deps
YEAR="${1:-${YEAR}}"
OUT_RAW="${DATA_DIR}/${YEAR}/raw"
OUT_CSV="${DATA_DIR}/${YEAR}/csv"
mkdir -p "${OUT_RAW}" "${OUT_CSV}"

banner "🥇 ${YEAR} 시즌 포디움 집계 (P1/P2/P3)"

run_with_spinner "전체 결과 다운로드(results.json)" \
  curl -s "${BASE}/${YEAR}/results.json?limit=1000" -o "${OUT_RAW}/results.json"

run_with_spinner "포디움 CSV 생성" \
  bash -c "
    jq -r '
      .MRData.RaceTable.Races
      | map(
          (.round|tonumber) as \$r
          | .Results[]
          | {round:\$r, driver:(.Driver.familyName), driverId:.Driver.driverId, position:(.position|tonumber)}
        )
      | map(select(.position<=3))
      | group_by(.driverId)
      | map({
          driverId: .[0].driverId,
          driver:   .[0].driver,
          podiums:  length,
          P1: (map(select(.position==1))|length),
          P2: (map(select(.position==2))|length),
          P3: (map(select(.position==3))|length)
        })
      | sort_by(-.podiums, .driver)
      | ( [\"driver\",\"podiums\",\"P1\",\"P2\",\"P3\"] | @csv ),
        ( .[] | [ .driver, .podiums, .P1, .P2, .P3 ] | @csv )
    ' '${OUT_RAW}/results.json' > '${OUT_CSV}/podiums.csv'
  "

progress_bar 80 40
f1_car_animation 50 1
echo -e "\033[1;32mCSV 저장:\033[0m ${OUT_CSV}/podiums.csv"
