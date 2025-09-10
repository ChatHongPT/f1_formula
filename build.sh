sudo tee ./f1_build.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

API="https://api.openf1.org/v1"
OUT="./f1_data"
mkdir -p "$OUT"

curl_json() { curl -fsSL "$1" || echo '[]'; }

# 1) 최신 세션 기준 데이터 수집 → 파일 저장
drivers_json="$(curl_json "$API/drivers?session_key=latest")"
if [ "$(jq 'length' <<<"$drivers_json")" -eq 0 ]; then
  echo "no drivers for latest session" >&2
  exit 1
fi
session_key="$(jq -r '.[0].session_key' <<<"$drivers_json")"

printf '%s' "$drivers_json" | jq '.' > "$OUT/drivers.json"
printf '%s' "$(curl_json "$API/sessions?session_key=$session_key")" | jq '.' > "$OUT/sessions.json"
printf '%s' "$(curl_json "$API/laps?session_key=$session_key")" | jq '.' > "$OUT/laps.json"
printf '%s' "$(curl_json "$API/pit?session_key=$session_key")" | jq '.' > "$OUT/pits.json"
printf '%s' "$(curl_json "$API/session_result?session_key=$session_key")" | jq '.' > "$OUT/results.json"

# 2) 팀 순위(세션 포인트 합산) - drivers와 조인
jq -s '
  .[0] as $results |
  .[1] as $drivers |
  $results |
  map(
    . as $r |
    ($drivers[] | select(.driver_number == $r.driver_number)) as $d |
    . + {team_name: ($d.team_name // "Unknown Team")}
  ) |
  group_by(.team_name) |
  map({team_name:(.[0].team_name // "Unknown Team"),
       points:(map(.points // 0) | add)}) |
  sort_by(-.points)
' "$OUT/results.json" "$OUT/drivers.json" | jq '.' > "$OUT/team_standings.json"

# 3) 포디움(Top 3) + headshot/team_colour 조인  (파일에서 직접 읽음)
#   results가 비면 drivers 상위 3명으로 대체
if [ "$(jq 'length' "$OUT/results.json")" -gt 0 ]; then
  jq -s '
    .[0] as $results |
    .[1] as $drivers |
    ($results | map(select(.position != null)) | sort_by(.position) | .[0:3]) as $top |
    $top |
    map(
      . as $r |
      ($drivers[] | select(.driver_number == $r.driver_number)) as $d |
      . + {
        headshot_url: ($d.headshot_url // null),
        team_colour: ($d.team_colour // "777777")
      }
    )
  ' "$OUT/results.json" "$OUT/drivers.json" | jq '.' > "$OUT/podium.json"
else
  jq '
    sort_by(.driver_number) | .[0:3] |
    to_entries |
    map({
      position: (.key + 1),
      driver_number: .value.driver_number,
      full_name: .value.full_name,
      team_name: (.value.team_name // "Unknown Team"),
      headshot_url: (.value.headshot_url // null),
      team_colour: (.value.team_colour // "777777")
    })
  ' "$OUT/drivers.json" | jq '.' > "$OUT/podium.json"
fi

# 4) 메타
jq -n \
  --arg sk "$(printf '%s' "$session_key")" \
  --arg loc  "$(jq -r '.[0].location     // empty' "$OUT/sessions.json")" \
  --arg name "$(jq -r '.[0].session_name // "Latest Session"' "$OUT/sessions.json")" \
  --arg date "$(jq -r '.[0].date_start   // empty' "$OUT/sessions.json")" \
  '{session_key:$sk, location:$loc, session_name:$name, date_start:$date}' | jq '.' \
  > "$OUT/meta.json"

echo "Generated JSON under $OUT"
EOF

# 개행문자 정리(혹시 Windows 개행 섞였을 경우)
sudo sed -i '' 's/\r$//' ./f1_build.sh
sudo chmod +x ./f1_build.sh
