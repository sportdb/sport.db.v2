# Football.TXT Format Todos



## Todos

- [x]  add heading support to lexer & parser and
       change text input from array of lines to multi-line string
       incl. comments and blank lines etc. (that is, remove Outliner)

- [ ]  use two lexers 
       - minimal   - no goal lines, no props, etc.
       - "maximal"  - supports goal lines, and props 

       
### Format Clean-up

- [x]  add heading1/2/3 etc. to parser rules
- [x]  remove (optional) \[\] from date
- [x]  remove support for "standalone weekday and weekday+hour only (require date!)
- [x]   change goal format - MUST start with and enclosed by (); 
           change minutes to goal minutes and 
           include optional  o.g., pen. WITHOUT enclosing ()!!!
           e.g.  (Benzema 51' Bale 64', 83'; Mané 55') or
                 (Benzema, Bale (2); Mané)
           or  multi-line-style  
               (Milner 15'og, Džeko 52', Nainggolan 86', 90+4'pen; 
                 Mané 9', Wijnaldum 25')   


- [ ]  check minute format (note - BBC uses  `45'+2` instead of `45+2'` - support or change - why? why not?)
       yes, change to the BBC style - use `45'+2`  !!!
- [ ]  clean-up lexer / tokens / regexes   
        - remove (standalone) weekday for now
        - remove list support
        - ...              
- [ ]  add back alternate goal line format (e.g  0-1 Milner 15', 1-1 Mané 12' etc.)
       - note - make minutes optional e.g. ( 0-1 Milner, 1-1 Mané)
- [ ]   simplify v (versus) - only allow `v` (remove `vs`) - why? why not?
- [ ]   "fix" alternatve goal line format ( allow (o.g.) and (pen.) plus (1),(2),(3) for score counts, plus (2/pen) or (3/2 pen) or such for score count PLUS penalty)
  - [ ]  goal line (no minutes) - check for  (o.g.) and (pen.) "real-world" samples and such if in use?

- [ ]   add  agg to "standard" full score format e.g.
           Rapid v Austria  3-2, 4-5 agg  or
           Rapid v Austria  3-2 (1-1), 4-5 agg   -- with semi-colon - why? why not?
           - check aggregate with aet, aet+pen, away goals, etc. !!!!!  

- [ ]  philosophical -   change `score: { et: [] }` to `score: { aet: [] }` - why? why not?
          - keep et: \[\] for extra time score only (NOT incl. full-time)
                      that is,  ft+et = aet  e.g.  \[1,1\] + \[1,0\] = \[2,1\]
                      
- add sudden death/golden goal option for extra time
  - asdet  (after sudden death extra time)
  - agget  (after golden goal extra time)
  - aet/gg (after extra time/golden goal)

 
----
more todos

- [ ]  add football boxes (matches) from <https://en.wikipedia.org/wiki/1871–72_FA_Cup>  incl. w/o from, byes and more!!!
- [ ] add rsssf samples for
        - <https://github.com/rsssf/brazil/blob/master/2010/1-seriea.txt>
        
  

## Planned / Clean-up


### Goal Line
- [x]  do NOT eat-up goal line starter; use "virtual" GOALS token (kind of INLINE_GOALS)!!!
- [x]  check for negative lookahead `(1)` - ord (number) for goal line starter 


### Time / Timezone

- [x]  yes, remove the `12.00`, `17.30` option from time! 
       only support `12:00`, `17:30` - `12h00`, `17h30`
- [x]  fix optional timezone  -   follow time w/o enclosing bracket e.g.
       `12:00 CEST` or `12:00 CEST/UTC+1` etc.  



### Score

- [ ]  allow "compact" no-spaces in score e.g.  `1-1(2-0)`
- [ ]  "auto-sort" enclosed score brackets e.g.  `(2-1,1-1)` or `(1-1,2-1)`
         to use highest for full-time and lowest for half-time;
         best practice in english is (ht, ft) or (ht, ft, et) !!!
- [ ]  remove dangling comma option ein encosed score brackets e.g. `(2-1,)` - why? why not?   used anywhere? e.g. `(0-0,)`




### Minutes

- [x]  allow  "double" minute markers too (if possible) - see on mlssoccer.com site
       e.g. `45'+1'`or `90'+5'`



## More
