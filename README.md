# F1 JQ Stats 🏎️💨

<img width="400" height="240" alt="image" src="https://github.com/user-attachments/assets/4eab21d3-b739-490e-a4ef-e8b6d77d899d" />

**F1 JQ Stats**는 [Ergast Developer API](http://ergast.com/mrd/)로부터 Formula 1 데이터를 가져와
`jq`로 가공·집계·CSV 저장까지 자동화하는 **Bash 기반 오픈소스 프로젝트**입니다.

- **데이터 수집** : 시즌별 드라이버·컨스트럭터 스탠딩, 경기별 포디움, 랩타임, 피트스톱 정보
- **데이터 처리** : `jq`를 사용해 JSON 평탄화 후 CSV 변환
- **자동 디렉토리 구성** : 시즌/라운드별 저장 구조 자동 생성
- **시각 효과** : 스피너, 프로그레스바, 🏎️💨 레이싱 애니메이션
- **결과물 활용** : CSV 파일로 저장하여 Python, Excel, Grafana 등에서 분석 가능

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
