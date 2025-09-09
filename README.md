# F1 JQ Stats 🏎️💨

<img width="400" height="240" alt="image" src="https://github.com/user-attachments/assets/4eab21d3-b739-490e-a4ef-e8b6d77d899d" />

**F1 JQ Stats**는 [Ergast Developer API](http://ergast.com/mrd/)로부터 Formula 1 데이터를 가져와
`jq`로 가공·집계·CSV 저장까지 자동화하는 **Bash 기반 오픈소스 프로젝트**입니다.

- **실시간 데이터 조회** : Ergast API에서 최신 F1 데이터를 실시간으로 조회
- **데이터 처리** : `jq`를 사용해 JSON을 CSV 형태로 변환하여 터미널에 출력
- **시각 효과** : 스피너, 프로그레스바, 🏎️💨 레이싱 애니메이션
- **결과물 활용** : 터미널 출력을 파이프라인으로 다른 도구와 연동 가능
- **입력 검증** : 연도, 라운드, 랩 번호 자동 검증 (1950-2030, 1-30, 1-100)
- **에러 핸들링** : API 응답 검증 및 JSON 파싱 오류 자동 감지
- **CSV 헤더** : 출력되는 데이터에 적절한 컬럼 헤더 자동 추가

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

스크립트 실행시 터미널에 CSV 형태로 출력됩니다:

```bash
# 드라이버 스탠딩
position,driver,constructor,points,wins
1,Max Verstappen,Red Bull Racing,575,19
2,Sergio Perez,Red Bull Racing,285,2

# 포디움 집계
driver,podiums,P1,P2,P3
Max Verstappen,19,19,0,0
Sergio Perez,2,0,2,0
```

## 라이선스

- Ergast Developer API는 비상업적 목적 사용 조건을 따릅니다.
- 본 프로젝트 코드는 MIT 라이선스를 추천합니다(원하시면 LICENSE 파일을 추가하세요).
