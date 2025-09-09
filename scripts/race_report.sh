#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

check_deps
YEAR="${1:-${YEAR}}"
ROUND="${2:-1}"
LAP="${3:-10}"

DIR="${DATA_DIR}/${YEAR}/rounds/${ROUND}"
mkdir -p "${DIR}"

banner "🏎️  ${YEAR} Round ${ROUND} 리포트 (Lap ${LAP}, Pitstops)"

run_with_spinner "Lap ${LAP} 랩타임 다운로드" \
  curl -s "${BASE}/${YEAR}/${ROUND}/laps/${LAP}.json?limit=1000" -o "${DIR}/lap${LAP}.json"

run_with_spinner "피트스톱 다운로드" \
  curl -s "${BASE}/${YEAR}/${ROUND}/pitstops.json?limit=1000" -o "${DIR}/pitstops.json"

run_with_spinner "Lap ${LAP} CSV 생성" \
  bash -c "
    jq -r '
      .MRData.RaceTable.Races[0].Laps[0].Timings[]
      | {driverId:.driverId, position:(.position|tonumber), time:.time}
      | [ .position, .driverId, .time ] | @csv
    ' '${DIR}/lap${LAP}.json' > '${DIR}/lap${LAP}.csv'
  "

run_with_spinner "Pitstops CSV 생성" \
  bash -c "
    jq -r '
      .MRData.RaceTable.Races[0].PitStops
      | map({lap:(.lap|tonumber), stop:(.stop|tonumber), driverId:.driverId, duration:.duration})
      | sort_by(.lap, .stop)
      | ( [\"lap\",\"stop\",\"driverId\",\"duration\"] | @csv ),
        ( .[] | [ .lap, .stop, .driverId, .duration ] | @csv )
    ' '${DIR}/pitstops.json' > '${DIR}/pitstops.csv'
  "

f1_car_animation 70 1
echo -e "\033[1;32m리포트 저장:\033[0m ${DIR}/lap${LAP}.csv, ${DIR}/pitstops.csv"
