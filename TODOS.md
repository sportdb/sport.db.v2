#  TODOS


- [ ] update all /openfootball datasets to football.txt v2 !!!





## Football.TXT v2 Update

- [x]   /euro
- [x]   /worldcup

- [x]   /england
- [x]   /south-america
- [x]   /champions-league
- [x]   /europe
- [x]   /italy

- [x]  /deutschland
- [x]  /espana
- [ ]  /internationals
- [x]  /club-worldcup
- [x]  /austria
- [x]  /belgium
- [ ]  /world
- [ ]  /worldcup.more
- [ ]  /world.more
- [ ]  /north-america-gold-cup
- [ ]  /copa-america


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
