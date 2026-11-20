# Nano Football.TXT

the idea - like tiny (or nano) basic - is a nano subset of
the football.TXT format  (yes, even simpler than tiny!)

for some background, see the tiny football.txt readme/docu



## (a tiny) format

line oriented:
- heading (competition) line (starting with `=` or `==` or `===` depending on heading level)
- round (header) line (starting with `▪`)
- date (header) line
- match line

note: all lines other than match lines are optional


match line rules:
- One match per line.
- v separates the teams.
- Scores, dates, and times are optional.


note - comments starting with `#` get stripped / auto-removed.


```
# Simple match fixtures
Arsenal v Chelsea
Liverpool v Everton

# Scores
Arsenal v Chelsea 2-1
Arsenal v Chelsea 2-1 (1-0)

# Extra time and penalties
Arsenal v Chelsea 2-2 aet
Arsenal v Chelsea 2-2 aet (1-1, 0-0)
Arsenal v Chelsea 2-2 aet (1-1, 0-0), 5-4 pen

# Dates and kickoff times
2025-08-15 Arsenal v Chelsea
2025-08-15 20:00 Arsenal v Chelsea 2-1
```



and the grammar


<!--
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
-->



```
document       := line*

line           := blank
                | heading          # or competition
                | round            # or stage / group / etc.
                | date             # (stand-alone) date header / line (note - date only; no time allowed)
                | match

heading        := "=" text      # e.g.   = Permier League 2026/27
round          := "▪" text      # e.g.   ▪ Round 1
                                #    or  ▪ Quarterfinals
                                #    or  ▪ Playoffs, Matchday 1

match          := date? time? home " v " away score?

date           := YYYY-MM-DD
time           := HH:MM
home           := team
away           := team

score          := result | result_details
result         := N-N
result_details := N-N details
```


score details format:

```
# SCORE/SCORE_BASIC
Arsenal v Chelsea   1-1             # (reported) result - might be FT or AET or awarded or ??
##  use  1-1 FT        to confirm (known) full-time score duration to parser
##                        instead of keeping duration unkown/undecided

# SCORE_FULL
## with half time
Arsenal  v Chelsea   1-1 (0-1)        # FT (HT)

## with (after) extra time
Arsenal München v Chelsea   1-1 aet                      # ET
Arsenal München v Chelsea   1-1 aet (1-1)                # ET (FT)
Arsenal München v Chelsea   1-1 aet (1-1, 0-0)           # ET (FT, HT)

## with penalty shootout
Arsenal v Chelsea   1-1 aet, 3-4 pen             # ET,          PEN
Arsenal v Chelsea   1-1 aet (1-1), 3-4 pen       # ET (FT),     PEN
Arsenal v Chelsea   1-1 aet (1-1, 0-0), 3-4 pen  # ET (FT, HT), PEN
Arsenal v Chelsea   3-4 pen                      #              PEN

Arsenal v Chelsea   1-1, 3-4 pen                 #     FT,      PEN - no extra time!
```


<!--

check  for adding  HT/FT e.g.
1-1 (HT 0-1)                       # FT (HT)
1-1 aet (FT 1-1), 3-4 pen          # ET (FT),     PEN
1-1 aet (FT 1-1, HT 0-0), 3-4 pen  # ET (FT, HT), PEN

-->



note:
- for `aet` (accepted) variants include `a.e.t.` or `a.e.t`
- for `pen` variants include `p` or  `pen.`






## todos

- [ ]  add optional ground / venue to match line (use `@` e.g. `@ Camp Nou, Barcelona`)
- [ ]  add optional (match) note to match line (use `[]` e.g. `[cancelled]` or `[abandoned at 64']`)



```
# Normal match
Arsenal v Chelsea 2-0

# Match abandoned
Arsenal v Chelsea 1-0 [abandoned]

# Match suspended
Arsenal v Chelsea 1-0 [suspended]

# Match postponed
Arsenal v Chelsea [postponed]

# Match cancelled
Arsenal v Chelsea [cancelled]

# Match awarded
Arsenal v Chelsea 3-0 [awarded]

# Walkover
Arsenal v Chelsea 3-0 [walkover]

# Match declared void
Arsenal v Chelsea 2-1 [void]
```




## (more) samples

nano football.txt sample

```
= Champions League

▪ Quarter-finals - 1st Leg
2024-04-01
  20:45   FC Barcelona        v Atlético Madrid    1-1  @ Camp Nou, Barcelona
  20:45   Manchester United   v Bayern München     1-1  @ Old Trafford, Manchester
2024-04-02
  20:45   Real Madrid         v Borussia Dortmund  3-0  @ Santiago Bernabéu, Madrid
  20:45   Paris Saint-Germain v Chelsea FC         3-1  @ Parc des Princes, Paris
```
