# Notes on Gems

How-to Update the paser and quick match reader gems



## "core" parser (& lexer)

**sportdb-parser**   (last updated in may 2026!)

depends on:  cocos   (code commons & quick starter prelude)



parser usage (cheat sheet):


``` ruby
parser = SportDb::Parser.new
tokens, errors = parser.tokenize_with_errors( txt, debug: true|false )
tree, errors   = parser.parse_with_errors( txt, debug: true|false)

# -or- "raw" parse usage:
#    note - parser incl. errors from lexer (tokenize)

parser = RaccMatchParser.new( txt, debug: true|false )
tree, errors = parser.parse_with_errors

parser.errors? & parser.errors


# -or- "raw" lexer usage:

lexer = SportDb::Lexer.new( txt, debug: true|false )
tokens, errors = lexer.tokenize_with_errors
```




## "quick" matcher reader (& football.txt to .json convert)

**sportdb-quick**   (last updated in may 2026!)

depends on: sportdb-parser, season-formats, logutils


usage:

``` ruby
matches = SportDb::QuickMatchReader.read( path )
matches = SportDb::QuickMatchReader.parse( txt )

# returns array of struct Match   (SportDb::MatchTree:Match)

# -or-

quick = SportDb::QuickMatchReader.new( txt )
matches = quick.parse

quick.matches
quick.league_name
quick.errors? & quick.errors
```


## todo
##  add "downstream"   commandline tools with dependencies !!!


**fbtok/fbtree (& fbquick/fbquik/fbx)**   (last updated in may 2026!)
depends-on:
- sportdb-parser   (fbtok/fbtree)
- sportdb-quick    (fbquick/fbquick/fbx)


**fbtxt2json/fbtxt2csv**      (last updated in may 2026!)
depends-on:
- fbtok  (incl. sportdb-parser & sportdb-quick)


**footty**     (last updated in may 2026!)
depends-on:
- sportdb-quick   (incl. sportdb-parser, season-formats, logutils)
- webget






### more

**fbup**
depends-on:
- gitti
- leagues         -- depends on: cocos, seasons-formats, tzinfo
- sportdb-writers -- depends on: sportdb-structs
