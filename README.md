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

       
