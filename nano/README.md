# Nano Football.TXT

the idea - like tiny (or nano) basic - is a nano subset of
the football.TXT format  (yes, even simpler than tiny!)

for some background, see the tiny football.txt readme/docu


## (a tiny) format

three rules:
- One match per line.
- v separates the teams.
- Scores, dates, and times are optional.



```
# Simple fixtures
Arsenal v Chelsea
Liverpool v Everton

# Scores
Arsenal v Chelsea 2-1
Arsenal v Chelsea 2-1 (1-0)

# Extra time and penalties
Arsenal v Chelsea 2-2 aet
Arsenal v Chelsea 2-2 aet (1-1, 0-0)
Arsenal v Chelsea 2-2 aet (1-1, 0-0), 5-4 pen.

# Dates and kickoff times
2025-08-15 Arsenal v Chelsea
2025-08-15 20:00 Arsenal v Chelsea 2-1
```


and the grammar

```
line        := blank | comment | fixture
comment     := "#" text
fixture     := date? time? home " v " away score?
date        := YYYY-MM-DD
time        := HH:MM
home        := team
away         := team
score        := result | result_details
result       := N-N
result_details := N-N details
```





## todo
- [ ] add competition (=) and round header (▪) lines