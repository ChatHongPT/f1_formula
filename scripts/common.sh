#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts"
DATA_DIR="${ROOT_DIR}/data"

# .env 로드
if [[ -f "${ROOT_DIR}/.env" ]]; then
  # shellcheck disable=SC1090
  source "${ROOT_DIR}/.env"
fi

: "${YEAR:=2024}"        # 기본 연도
: "${BASE:=http://ergast.com/api/f1}"

mkdir -p "${DATA_DIR}"

check_deps() {
  local missing=()
  command -v curl >/dev/null 2>&1 || missing+=("curl")
  command -v jq >/dev/null 2>&1 || missing+=("jq")
  if (( ${#missing[@]} > 0 )); then
    echo "필요한 도구가 없습니다: ${missing[*]}"
    echo "Ubuntu 예) sudo apt-get update && sudo apt-get install -y jq curl"
    exit 1
  fi
}

# 공용 출력
banner() {
  local msg="$1"
  echo -e "\n\033[1;33m$msg\033[0m"
}

# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/animation.sh"
