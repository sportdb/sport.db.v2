# Football.TXT Format Todos


## Planned / Clean-up


### Goal Line
- [ ]  do NOT eat-up goal line starter; use "virtual" GOALS token (kind of INLINE_GOALS)!!!
- [ ]  check for negative lookahead `(1)` - ord (number) for goal line starter 


### Time / Timezone

- [ ]  yes, remove the `12.00`, `17.30` option from time! 
       only support `12:00`, `17:30` - `12h00`, `17h30`
- [ ]  fix optional timezone  -   follow time w/o enclosing bracket e.g.
       `12:00 CEST` or `12:00 CEST/UTC+1` etc.  

### Score

- [ ]  allow "compact" no-spaces in score e.g.  `1-1(2-0)`
- [ ]  "auto-sort" enclosed score brackets e.g.  `(2-1,1-1)` or `(1-1,2-1)`
         to use highest for full-time and lowest for half-time;
         best practice in english is (ht, ft) or (ht, ft, et) !!!
- [ ]  remove dangling comma option ein encosed score brackets e.g. `(2-1,)` - why? why not?   used anywhere? e.g. `(0-0,)`




### Minutes

- [ ]  allow  "double" minute markers too (if possible) - see on mlssoccer.com site
       e.g. `45'+1'`or `90'+5'`



## More
