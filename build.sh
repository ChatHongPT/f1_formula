sudo apt update
sudo apt install -y nginx jq curl
sudo mkdir -p /f1 /var/www/html/f1/data

sudo tee /f1/build.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

API="https://api.openf1.org/v1"
OUT="/var/www/html/f1/data"
mkdir -p "$OUT"

# 1) 최신 세션 키 찾기 (drivers에서 하나 집어와도 충분)
drivers_json="$(curl -sS "$API/drivers?session_key=latest")"
len="$(echo "$drivers_json" | jq 'length')"
if [ "$len" -eq 0 ]; then
  echo "no drivers for latest session" >&2
  exit 1
fi
session_key="$(echo "$drivers_json" | jq -r '.[0].session_key')"

# 2) 세션/드라이버/랩/피트/결과 수집
sessions_json="$(curl -sS "$API/sessions?session_key=${session_key}")" || sessions_json="[]"
laps_json="$(curl -sS "$API/laps?session_key=${session_key}")" || laps_json="[]"
pits_json="$(curl -sS "$API/pit?session_key=${session_key}")" || pits_json="[]"
results_json="$(curl -sS "$API/session_result?session_key=${session_key}")" || results_json="[]"

# 3) 파일로 저장
echo "$drivers_json"  > "$OUT/drivers.json"
echo "$sessions_json" > "$OUT/sessions.json"
echo "$laps_json"     > "$OUT/laps.json"
echo "$pits_json"     > "$OUT/pits.json"
echo "$results_json"  > "$OUT/results.json"

# 4) 팀 순위(세션 포인트 합산) 계산
# results: [{full_name, team_name, position, points, ...}]
team_table="$(echo "$results_json" \
  | jq -r '
      group_by(.team_name) |
      map({
        team_name: (.[0].team_name // "Unknown Team"),
        points: (map(.points // 0) | add)
      }) | sort_by(-.points)
    ')"
echo "$team_table" > "$OUT/team_standings.json"

# 5) 포디움(Top 3) 추출 + headshot 채우기(드라이버 목록 조인)
podium="$(jq -n --argjson R "$results_json" --argjson D "$drivers_json" '
  # 결과에서 상위 3명만
  ($R | sort_by(.position) | map(select(.position >= 1)) | .[0:3]) as $top |
  $top
  | map(. + (
      # 드라이버 목록과 driver_number로 조인해 headshot/team_colour 얻기
      ($D | map(select(.driver_number == .driver_number)) |
       map(select(.driver_number == .driver_number))) as $noop
    ))
')"
# 위 조인은 noop이라 의미 없음 → 제대로 조인
podium="$(jq -n --argjson R "$results_json" --argjson D "$drivers_json" '
  ($R | sort_by(.position) | .[0:3]) as $top
  | $top
  | map(. + (
      ($D | map(select(.driver_number == .driver_number))) as $no  # placeholder
    ))
')"
# 실제 조인 구현
podium="$(jq -n --argjson R "$results_json" --argjson D "$drivers_json" '
  ($R | sort_by(.position) | .[0:3]) as $top
  | $top
  | map(. as $r |
        ($D | map(select(.driver_number == $r.driver_number)) | .[0]) as $d |
        . + {
          headshot_url: ($d.headshot_url // null),
          team_colour:  ($d.team_colour  // "777777")
        })
')"
echo "$podium" > "$OUT/podium.json"

# 6) 메타
jq -n --arg sk "$session_key" \
      --arg loc "$(echo "$sessions_json" | jq -r '.[0].location // empty')" \
      --arg name "$(echo "$sessions_json" | jq -r '.[0].session_name // "Latest Session"')" \
      --arg date "$(echo "$sessions_json" | jq -r '.[0].date_start // empty')" \
      '{session_key:$sk, location:$loc, session_name:$name, date_start:$date}' \
      > "$OUT/meta.json"

echo "Generated JSON under $OUT"
EOF

sudo chmod +x /f1/build.sh
sudo /f1/build.sh
