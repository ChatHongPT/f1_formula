#!/usr/bin/env bash
# jq 필터들을 bash 변수로 보관 (싱글쿼트 유지)

driver_standings_filter='
.MRData.StandingsTable.StandingsLists[0].DriverStandings[]
| {pos:(.position|tonumber),
   points:(.points|tonumber),
   wins:(.wins|tonumber),
   driver:(.Driver.givenName+" "+.Driver.familyName),
   constructor:.Constructors[0].name,
   driverId:.Driver.driverId}
'

constructor_standings_filter='
.MRData.StandingsTable.StandingsLists[0].ConstructorStandings[]
| {pos:(.position|tonumber),
   constructor:.Constructor.name,
   points:(.points|tonumber),
   wins:(.wins|tonumber)}
'
