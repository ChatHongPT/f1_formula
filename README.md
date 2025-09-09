# F1 JQ Stats 🏎️💨

<img width="400" height="240" alt="image" src="https://github.com/user-attachments/assets/4eab21d3-b739-490e-a4ef-e8b6d77d899d" />

**F1 JQ Stats**는 [Ergast Developer API](http://ergast.com/mrd/)로부터 Formula 1 데이터를 가져와
`jq`로 가공·집계·CSV 저장까지 자동화하는 **Bash 기반 오픈소스 프로젝트**입니다.

- **데이터 수집** : 시즌별 드라이버·컨스트럭터 스탠딩, 경기별 포디움, 랩타임, 피트스톱 정보
- **데이터 처리** : `jq`를 사용해 JSON 평탄화 후 CSV 변환
- **자동 디렉토리 구성** : 시즌/라운드별 저장 구조 자동 생성
- **시각 효과** : 스피너, 프로그레스바, 🏎️💨 레이싱 애니메이션
- **결과물 활용** : CSV 파일로 저장하여 Python, Excel, Grafana 등에서 분석 가능
- **입력 검증** : 연도, 라운드, 랩 번호 자동 검증 (1950-2030, 1-30, 1-100)
- **에러 핸들링** : API 응답 검증 및 JSON 파싱 오류 자동 감지
- **CSV 헤더** : 모든 CSV 파일에 적절한 컬럼 헤더 자동 추가

## 기술 스택

### 핵심 도구

- **Bash** - 스크립트 실행 환경
- **jq** - JSON 데이터 처리 및 변환
- **curl** - HTTP API 호출
- **make** - 빌드 자동화 (선택사항)

### 데이터 소스

- **Ergast Developer API** - Formula 1 공식 데이터 API
- **JSON** - API 응답 형식
- **CSV** - 최종 출력 형식

### 개발 환경

- **Shell Scripting** - Bash 기반 자동화
- **Git** - 버전 관리
- **Makefile** - 명령어 단축

## 요구사항

- bash, curl, jq
- (선택) make

Ubuntu 설치 예시:

```bash
sudo apt-get update && sudo apt-get install -y jq curl make
```

## 빠른 시작

```bash
# 1) 권한 + 초기화
chmod +x scripts/*.sh
bash scripts/init.sh 2024

# 2) 시즌 스탠딩
bash scripts/standings.sh 2024

# 3) 포디움 집계
bash scripts/podiums.sh 2024

# 4) 라운드 리포트 (예: 2024 시즌, 라운드 1, 10랩)
bash scripts/race_report.sh 2024 1 10
```

Makefile 사용:

```bash
make init YEAR=2024
make standings YEAR=2024
make podiums YEAR=2024
make report YEAR=2024 ROUND=1 LAP=10
```

## 출력

- `data/<YEAR>/csv/driver_standings.csv`
- `data/<YEAR>/csv/constructor_standings.csv`
- `data/<YEAR>/csv/podiums.csv`
- `data/<YEAR>/rounds/<ROUND>/lap<LAP>.csv`
- `data/<YEAR>/rounds/<ROUND>/pitstops.csv`

## 라이선스

- Ergast Developer API는 비상업적 목적 사용 조건을 따릅니다.
- 본 프로젝트 코드는 MIT 라이선스를 추천합니다(원하시면 LICENSE 파일을 추가하세요).
