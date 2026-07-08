# How-Tos


## parse check .txt datafiles using fbtree

in /sports/openfootball use:

```
$ fbtree  internationals  -q        ## use the -q/--quiet flag
```


results in

```
[[:OK, "C:/sports/openfootball/internationals/afc_asian_cup/1956_afc_asian_cup.txt", "24 tree node(s)"],
 [:OK, "C:/sports/openfootball/internationals/afc_asian_cup/1960_afc_asian_cup.txt", "24 tree node(s)"],
  ...]

OK   no parse errors found in 1935 datafile(s)
```


---

## TODO/FIX

- [ ] remove deprecated parse call in fbtree!!

```
==> [1/1, 1935/1935] reading >C:/sports/openfootball/internationals/uefa_nations_league/2025_uefa_nations_league.txt<...
[DEPRECATED] parse; use new (porcelain/public) Fbtxt.parse api!!
   28 MatchLine(s)
   27 GoalLine(s)
```