#  TODOS


- [ ] update all /openfootball datasets to football.txt v2 !!!


### repos

36 repos

openfootball datasets include:
 -- clubs
   /europe
     /champions-league
     /england
     /deutschland
     /italy
     /espana
     /austria
     /belgium
   /south-america
   /world
   /world.more
   /club-worldcup

 -- natis  (national teams)
    /worldcup
    /worldcup.more
    /euro
    /copa-america
    /north-america-gold-cup
    /internationals

 -- misc
    /openfootball.github.io    -- website
    /opendata-theme
    /spec
    /awesome-football          -- links
    /worldcup.json
    /football.json
    /euro.json
    /quick-starter
    /league-starter
    /v0-format
    /leagues
    /clubs
    /players
    /sandbox
    /help
    /schema.sql
    /docs
    /schema


## Football.TXT v2 Update

- [x]   /euro
- [x]   /worldcup
- [x]  /north-america-gold-cup
- [x]  /copa-america

- [x]   /england
- [x]   /south-america
- [x]   /champions-league
- [x]   /europe
- [x]   /italy
- [x]  /deutschland
- [x]  /espana
- [x]  /club-worldcup
- [x]  /austria
- [x]  /belgium
- [x]  /world
- [x]  /world.more

- [x]  /internationals
- [ ]  /worldcup.more

- ...



how-to autofix / update format:


up .gitignore - add

```
####
#  all generated json output and in pages publish/deploy directory
_site/
*.json

*.v26*.txt
*.v2.txt
```

check for subsections (h2/h3 etc.) e.g. search for `==`


try conversion (autofixes):


```
$  ruby fmtfix/fbi2ii.rb   england/2000-01/1-premierleague.txt
```
