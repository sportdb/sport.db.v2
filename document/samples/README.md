# Football.TXT Samples

try dump of the football.txt document using `fbdoc` e.g.

```
fbdoc -h       # get command-line help / options

fbdoc worldcup_2022_final.txt      # w/ auto-lookup in  document/samples dir


fbdoc euro/2021--europe/euro.txt
fbdoc euro/2024--germany/euro.txt
fbdoc euro/2028--united_kingdom-ireland/euro.txt

##  check for time_local e.g.   18:00 (17:00 UTC+1)
##    [:TIME,       ["18:00",         {:h=>18, :m=>0}]]
##    [:TIME_LOCAL, ["(17:00 UTC+1)", {:h=>17, :m=>0, :timezone=>"UTC+1"}]]
##                              21:00 (20:00 UTC+1)
##    [:TIME,       ["21:00",         {:h=>21, :m=>0} ]]
##    [:TIME_LOCAL, ["(20:00 UTC+1)", {:h=>20, :m=>0, :timezone=>"UTC+1"} ]]
##


fbdoc deutschland/2024-25/1-bundesliga.txt
fbdoc world/pacific/australia/2023-24_au1.txt

fbdoc worldcup/2022--qatar/cup_finals.txt

fbdoc champions-league/2024-25/cl.txt
fbdoc champions-league/2022-23/cl.txt



## rsssf samples
fbdoc euro/rsssf/60e.txt
fbdoc euro/rsssf/2024e.txt

fbdoc england/rsssf/engcup1873.txt
fbdoc england/rsssf/eng2025-premierleague.txt
fbdoc england/rsssf/eng2024-playoffs.txt

fbdoc deutschland/rsssf/duit64.txt
fbdoc deutschland/rsssf/duit65.txt
fbdoc deutschland/rsssf/duit2025.txt

fbdoc austria/rsssf/oost2025.txt
fbdoc austria/rsssf/oost2025_cup.txt
fbdoc austria/rsssf/oost01.txt
```


more

```
fbdoc 1930_full.txt             # w/ auto-lookup in openfootball/worldcup/more dir
```