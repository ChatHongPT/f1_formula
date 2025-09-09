SHELL := /usr/bin/env bash

.PHONY: init standings podiums report

init:
	chmod +x scripts/*.sh
	bash scripts/init.sh $(YEAR)

standings:
	bash scripts/standings.sh $(YEAR)

podiums:
	bash scripts/podiums.sh $(YEAR)

report:
	# 사용 예: make report YEAR=2024 ROUND=1 LAP=10
	bash scripts/race_report.sh $(YEAR) $(ROUND) $(LAP)
