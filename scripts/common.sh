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

# 입력 검증 함수들
validate_year() {
  local year="$1"
  if [[ ! "$year" =~ ^[0-9]{4}$ ]] || [[ "$year" -lt 1950 ]] || [[ "$year" -gt 2030 ]]; then
    echo "❌ 잘못된 연도: $year (1950-2030 사이의 4자리 숫자여야 함)"
    exit 1
  fi
}

validate_round() {
  local round="$1"
  if [[ ! "$round" =~ ^[0-9]+$ ]] || [[ "$round" -lt 1 ]] || [[ "$round" -gt 30 ]]; then
    echo "❌ 잘못된 라운드: $round (1-30 사이의 숫자여야 함)"
    exit 1
  fi
}

validate_lap() {
  local lap="$1"
  if [[ ! "$lap" =~ ^[0-9]+$ ]] || [[ "$lap" -lt 1 ]] || [[ "$lap" -gt 100 ]]; then
    echo "❌ 잘못된 랩: $lap (1-100 사이의 숫자여야 함)"
    exit 1
  fi
}

# API 응답 검증
check_api_response() {
  local file="$1"
  local description="$2"
  
  if [[ ! -f "$file" ]] || [[ ! -s "$file" ]]; then
    echo "❌ $description 다운로드 실패: 파일이 비어있거나 존재하지 않음"
    exit 1
  fi
  
  # JSON 유효성 검사
  if ! jq empty "$file" 2>/dev/null; then
    echo "❌ $description JSON 파싱 실패"
    exit 1
  fi
  
  # API 에러 응답 확인
  if jq -e '.MRData == null' "$file" >/dev/null 2>&1; then
    echo "❌ $description API 에러 응답"
    jq -r '.error // "알 수 없는 에러"' "$file" 2>/dev/null || echo "API 응답 형식 오류"
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
