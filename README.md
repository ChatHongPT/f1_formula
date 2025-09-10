# F1 Live Dashboard 🏎️💨

<img width="400" height="240" alt="F1 Dashboard" src="F1-Logo.png" />

**F1 Live Dashboard**는 실시간 Formula 1 데이터를 시각화하는 **웹 기반 대시보드**입니다.

- **실시간 레이싱 시뮬레이션** : SVG 기반 F1 트랙에서 자동차 애니메이션
- **라이브 데이터 대시보드** : 포디움, 팀 순위, 피트스탑, 랩타임 실시간 표시
- **인터랙티브 UI** : 탭 기반 데이터 전환 및 드라이버 선택
- **현대적 디자인** : F1 브랜드 컬러와 글래스모피즘 효과
- **반응형 레이아웃** : 모바일/태블릿/데스크톱 지원
- **실시간 업데이트** : OpenF1 API 데이터 기반 자동 갱신

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

### 🏎️ 실시간 레이싱 시뮬레이션

- SVG 기반 F1 트랙
- 팀 컬러 자동차 애니메이션
- 랜덤 속도 변화로 추월 연출

### 📊 라이브 데이터 대시보드

- **포디움**: 1-3위 드라이버 정보
- **팀 순위**: 실시간 포인트 집계
- **피트스탑**: 최신 피트스탑 기록
- **랩타임**: 드라이버별 랩타임 분석

### 🎨 현대적 UI/UX

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

## 라이선스

- OpenF1 API는 비상업적 목적 사용 조건을 따릅니다.
- 본 프로젝트 코드는 MIT 라이선스를 추천합니다.
