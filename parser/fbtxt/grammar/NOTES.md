
# racc (parser) notes


## default actions

for empty list/rule      -   result = []
 return [] for empty list  -  kind of same as result = val if val = []??



for non-empty list/rule    - result = val  (where val is [val[0],val[1],...])

 return result = val ??
 e.g.

  | TEAM   =   result = val   is same as  result = [val[0]]
  | TEAM1 TEAM2   =                       result = [val[0],val[1]]


##  UPPER_CASE not only for tokens

in racc UPPER_CASE is not reserved for tokens only,
you can use it for production rules too.


in Football.TXT UPPER_CASE gets used
if a production rules is only for alternate tokens
e.g.   SCORE_FULL | SCORE_FULLER

resulting in:

```
  SCORE_FULL_OR_FULLER  : SCORE_FULL | SCORE_FULLER
  not
  score_full_or_fuller :  SCORE_FULL | SCORE_FULLER
```

the idea is - that you still have the "raw" token (object) as value
and NOT the token's value (e.g. a hash/str/int/etc.)!!!
