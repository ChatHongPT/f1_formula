#!/usr/bin/env bash
# Visual helpers: spinner / progress bar / F1 car

__spinner_watch() {
  local pid="$1"
  local msg="$2"
  local delay=0.08
  local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  tput civis 2>/dev/null || true
  while kill -0 "$pid" 2>/dev/null; do
    for s in "${spin[@]}"; do
      printf "\r\033[1;36m[%s]\033[0m %s" "$s" "$msg"
      sleep "$delay"
      kill -0 "$pid" 2>/dev/null || break
    done
  done
  wait "$pid" 2>/dev/null
  printf "\r\033[1;32m[✔]\033[0m %s\033[0K\n" "$msg"
  tput cnorm 2>/dev/null || true
}

# 사용법: run_with_spinner "메시지" cmd arg...
run_with_spinner() {
  local msg="$1"; shift
  ( "$@" ) &
  local pid=$!
  __spinner_watch "$pid" "$msg"
}

progress_bar() {
  local total=${1:-100}
  local width=${2:-40}
  for i in $(seq 1 "$total"); do
    local filled=$((i * width / total))
    local empty=$((width - filled))
    printf "\r\033[1;34m[%-*.*s%*s]\033[0m %3d%%" \
      "$filled" "$filled" "########################################" \
      "$empty" "" $((i*100/total))
    sleep 0.02
  done
  printf "\n"
}

# F1 차 이모지 애니메이션
f1_car_animation() {
  local track_width=${1:-60}
  local laps=${2:-2}
  local car="🏎️💨"
  for _ in $(seq 1 "$laps"); do
    for x in $(seq 0 "$track_width"); do
      printf "\r\033[1;31m%*s%s\033[0m" "$x" "" "$car"
      sleep 0.01
    done
  done
  printf "\r\033[1;32m🏁 Finish!\033[0m\033[0K\n"
}
