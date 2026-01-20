#  Football.TXT (Minimal) Tooling   a.k.a. sport.db.v2

## Update 2026

Q: What's different from v1?

In v1 the focus was on a shared database schema (a.k.a. football.db). 

In v2 the shared database schema no longer matters. 
What matters is the Football.TXT format and the lexer & parser to 
read into structs that can than get exported to JSON or CSV.

(SQL) database import is an optional extra and no longer part of the core tooling and there's no longer a one and only canoncial shared (SQL) database schema. 





## Todos

- [ ]  add heading support to lexer & parser and
       change text input from array of lines to multi-line string
       incl. comments and blank lines etc. (that is, remove Outliner)

- [ ]  use two lexers 
       - minimal   - no goal lines, no props, etc.
       - "maximal"  - supports goal lines, and props 

       
### Format Clean-up

- [ ]  add heading1/2/3 etc. to parser rules
- [ ]  remove (optional) \[\] from date
- [ ]  remove support for "standalone weekday and weekday+hour only (requires date!)
- [ ]   change goal format - MUST start with and enclosed by (); 
           change minutes to goal minutes and 
           include optional  o.g., pen. WITHOUT enclosing ()!!!
           e.g.  (Benzema 51' Bale 64', 83'; Mané 55')
                 (Benzema, Bale 2; Mané)
           or  multi-line-style  
               (Milner 15'og, Džeko 52', Nainggolan 86', 90+4'pen; 
                 Mané 9', Wijnaldum 25')      
                  