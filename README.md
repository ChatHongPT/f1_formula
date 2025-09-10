# 🏎️ F1-Formula

<img width="400" height="240" alt="F1 Dashboard" src="F1-Logo.png" />

**F1 Live Dashboard**는 실시간 Formula 1 데이터를 시각화하는 **웹 기반 대시보드**입니다.

- **실시간 레이싱 시뮬레이션** : SVG 기반 F1 트랙에서 자동차 애니메이션
- **라이브 데이터 대시보드** : 포디움, 팀 순위, 피트스탑, 랩타임 실시간 표시
- **인터랙티브 UI** : 탭 기반 데이터 전환 및 드라이버 선택
- **현대적 디자인** : F1 브랜드 컬러와 글래스모피즘 효과
- **반응형 레이아웃** : 모바일/태블릿/데스크톱 지원
- **실시간 업데이트** : OpenF1 API 데이터 기반 자동 갱신

## 팀원

|                                                   최홍석                                                   |                                                   홍윤기                                                   |
| :--------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------: |
| <img width="160px" src="https://github.com/user-attachments/assets/02386ffc-793b-49ec-b0e2-41f088b5f52f"/> | <img width="150px" src="https://github.com/user-attachments/assets/e8fdc284-987f-45a4-9cdc-d473dcbcc5bb"/> |
|                                [@ChatHongPT](https://github.com/ChatHongPT)                                |                             [@yunkihong-dev](https://github.com/yunkihong-dev)                             |

## 기술 스택

### 프론트엔드

- **HTML5** - 시맨틱 마크업
- **CSS3** - 현대적 스타일링 (CSS Grid, Flexbox, 애니메이션)
- **JavaScript (ES6+)** - 동적 데이터 처리 및 애니메이션
- **SVG** - 벡터 기반 트랙 및 자동차 렌더링

### 데이터 처리

- **jq** - JSON 데이터 변환 및 집계
- **Bash Scripting** - 데이터 수집 자동화
- **OpenF1 API** - 실시간 F1 데이터 소스

### 서버

- **Python HTTP Server** - 정적 파일 서빙
- **JSON API** - 실시간 데이터 엔드포인트

## 요구사항

- Python 3.x
- bash, curl, jq
- (선택) make

Ubuntu 설치 예시:

```bash
sudo apt-get update && sudo apt-get install -y python3 jq curl make
```

## 빠른 시작

### 1. 데이터 수집

```bash
# F1 데이터 수집 및 JSON 변환
bash build.sh
```

### 2. 웹 서버 시작

```bash
# Python HTTP 서버 시작 (포트 8081)
cd /Users/hongttochi/f1_formula
python3 -m http.server 8081
```

### 3. 대시보드 접속

브라우저에서 **http://localhost:8081/var/www/html/f1/** 접속

## 주요 기능

#### 실시간 레이싱 시뮬레이션

- SVG 기반 F1 트랙
- 팀 컬러 자동차 애니메이션
- 랜덤 속도 변화로 추월 연출

#### 라이브 데이터 대시보드

- **포디움**: 1-3위 드라이버 정보
- **팀 순위**: 실시간 포인트 집계
- **피트스탑**: 최신 피트스탑 기록
- **랩타임**: 드라이버별 랩타임 분석

#### 현대적 UI/UX

- F1 브랜드 컬러 (빨간색 그라데이션)
- 글래스모피즘 효과
- 반응형 디자인
- 부드러운 애니메이션

## 프로젝트 구조

```
f1_formula/
├── var/www/html/f1/          # 웹 대시보드 파일
│   └── index.html            # 메인 HTML 파일
├── f1_data/                  # JSON 데이터 파일
│   ├── drivers.json         # 드라이버 정보
│   ├── results.json         # 레이스 결과
│   ├── team_standings.json  # 팀 순위
│   ├── podium.json          # 포디움 데이터
│   ├── pits.json            # 피트스탑 데이터
│   └── laps.json            # 랩타임 데이터
├── build.sh                 # 데이터 수집 스크립트
├── F1-Logo.png             # F1 로고 이미지
└── README.md               # 프로젝트 문서
```

## jq 스크립트 상세 설명

### 데이터 수집 및 변환 과정

#### 1. OpenF1 API 데이터 수집

```bash
# build.sh에서 생성되는 f1_build.sh의 주요 jq 필터들
```

#### 2. 드라이버 데이터 처리

```jq
# drivers.json 생성
curl -s "https://api.openf1.org/v1/drivers" | jq '
  map({
    driver_number: .driver_number,
    full_name: .full_name,
    team_name: .team_name,
    team_colour: .team_colour,
    headshot_url: .headshot_url
  }) | sort_by(.driver_number)
' > drivers.json
```

#### 3. 포디움 데이터 집계

```jq
# podium.json 생성 - null position 필터링
jq -s '
  map(select(.position != null)) |
  group_by(.driver_number) |
  map({
    driver_number: .[0].driver_number,
    full_name: .[0].full_name,
    team_name: .[0].team_name,
    position: .[0].position,
    headshot_url: .[0].headshot_url
  }) |
  sort_by(.position)
' results.json > podium.json
```

#### 4. 팀 순위 계산

```jq
# team_standings.json 생성 - 드라이버와 결과 조인
jq -s '
  .[0] as $drivers |
  .[1] as $results |
  $results |
  map(select(.position != null)) |
  group_by(.driver_number) |
  map({
    driver_number: .[0].driver_number,
    team_name: ($drivers | map(select(.driver_number == .[0].driver_number)) | .[0].team_name),
    points: (map(.points // 0) | add),
    wins: (map(select(.position == 1)) | length)
  }) |
  group_by(.team_name) |
  map({
    team_name: .[0].team_name,
    points: (map(.points) | add),
    wins: (map(.wins) | add)
  }) |
  sort_by(.points) | reverse
' drivers.json results.json > team_standings.json
```

#### 5. 피트스탑 데이터 정렬

```jq
# pits.json 생성 - 최신순 정렬
jq '
  sort_by(.lap_number) | reverse |
  map({
    lap_number: .lap_number,
    driver_number: .driver_number,
    duration: .duration
  })
' pits.json
```

#### 6. 랩타임 데이터 처리

```jq
# laps.json 생성 - 드라이버별 그룹화
jq '
  group_by(.driver_number) |
  map({
    driver_number: .[0].driver_number,
    laps: map({
      lap_number: .lap_number,
      lap_time: .lap_time
    }) | sort_by(.lap_number)
  })
' laps.json
```

### jq 활용 기법

1. **데이터 필터링**: `select()` 함수로 조건부 데이터 추출
2. **그룹화**: `group_by()` 함수로 데이터 집계
3. **조인**: `-s` 옵션으로 여러 파일 조합
4. **정렬**: `sort_by()` 함수로 데이터 정렬
5. **집계**: `map()` + `add` 함수로 합계 계산
6. **null 처리**: `//` 연산자로 기본값 설정

## 웹 페이지 화면
<img width="1440" height="900" alt="스크린샷 2025-09-10 오전 9 52 49" src="https://github.com/user-attachments/assets/3b3b0d8d-5e3d-4ed0-a458-bdc78246949b" />

## 웹 실행 영상
![화면 기록 2025-09-10 오전 9 32 41-2](https://github.com/user-attachments/assets/a5307e18-133a-49fa-8f11-2e9d5893d8df)


## 트러블슈팅 회고

#### 주요 문제점들과 해결 과정

##### 1. Nginx 권한 문제 (403 Forbidden)

**문제**: Nginx가 파일에 접근할 수 없어 403 에러 발생

```
nginx: [error] "/path/to/index.html" is forbidden (13: Permission denied)
```

**해결 과정**:

- 파일 권한 확인: `ls -la`
- 소유자 변경 시도: `chown nobody:nogroup`
- 권한 설정: `chmod 755/644`
- **최종 해결**: Python HTTP 서버로 전환

##### 2. jq 버전 호환성 문제

**문제**: `--argfile` 옵션이 일부 jq 버전에서 지원되지 않음

```
jq: Unknown option --argfile
```

**해결 과정**:

- `--argfile` → `-s` (slurp) 옵션으로 변경
- 여러 파일을 배열로 읽어서 처리
- 더 넓은 jq 버전 호환성 확보

##### 3. JSON 데이터 경로 불일치

**문제**: HTML에서 `/f1/data/` 경로로 요청하지만 Python 서버는 `/f1_data/` 경로

```
GET /f1/data/meta.json HTTP/1.1" 404
```

**해결 과정**:

- 서버 로그 확인으로 404 원인 파악
- HTML JavaScript의 base 경로 수정
- `const base = '/f1_data';`로 변경

##### 4. 포디움 데이터 빈 값 문제

**문제**: `podium.json`이 비어있음 (null position 처리 누락)

**해결 과정**:

- jq 필터에 `map(select(.position != null))` 추가
- DNF/DNS 드라이버의 null position 필터링
- 데이터 검증 로직 강화

##### 5. 팀 순위 "Unknown Team" 문제

**문제**: 모든 팀이 "Unknown Team"으로 표시

**해결 과정**:

- 드라이버 데이터와 결과 데이터 조인 필요성 파악
- jq `-s` 옵션으로 다중 파일 처리
- `$drivers` 변수로 드라이버 정보 참조

## 회고

### 최홍석

> 이번 프로젝트를 통해 jq를 활용한 실시간 F1 데이터 처리 시스템을 구현하면서, 단순한 JSON 파싱뿐만 아니라 `group_by`와 `map`을 통한 복잡한 데이터 집계의 중요성을 체감했습니다. 특히, OpenF1 API에서 받아온 원시 데이터를 사용자 친화적인 형태로 변환하는 과정에서 많은 시행착오를 겪었지만, `--argfile` 호환성 문제를 `-s` 옵션으로 해결하면서 크로스 플랫폼 지원 측면의 경험치를 크게 쌓을 수 있었습니다. Nginx 권한 문제로 403 에러가 발생했을 때 Python HTTP 서버로 전환한 결정이 프로젝트 완성도를 높였고, null position 값 필터링을 통해 DNF/DNS 드라이버 처리 로직을 개선한 점이 인상적이었습니다.

### 홍윤기

> `requestAnimationFrame`과 SVG `getPointAtLength`를 이용해 F1 트랙에서 자동차 애니메이션을 실시간으로 구현하고, 랜덤 부스트 시스템으로 추월 연출을 만든 것이 인상적이었습니다. 개발 단계에서 CSS Grid와 Flexbox를 활용해 반응형 레이아웃을 구현하며, 글래스모피즘 효과와 F1 브랜드 컬러를 조합한 디자인을 개선했습니다. 특히, 단순한 데이터 표시를 넘어 탭 인터페이스와 드라이버 선택 기능을 추가해 사용자가 직관적으로 데이터를 탐색할 수 있도록 만든 점이 프로젝트의 완성도를 높였습니다. `path.getTotalLength()`와 `getPointAtLength()`를 활용한 SVG 경로 기반 애니메이션 구현 과정에서 벡터 그래픽의 확장성을 깊이 이해할 수 있었습니다.

---

## 라이선스

- OpenF1 API는 비상업적 목적 사용 조건을 따릅니다.
- 본 프로젝트 코드는 MIT 라이선스를 추천합니다.
