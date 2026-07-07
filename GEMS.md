# Notes on Gems

How-to Update the paser and quick match reader gems



## "core" parser (& lexer)

**fbtxt-parser**   (last updated in may 2026!)

depends on:  cocos   (code commons & quick starter prelude)


parser usage (cheat sheet):


``` ruby
parser = Fbtxt::Parser.new( txt )
tree, errors   = parser.parse_with_errors

# -or- "raw" lexer usage:

lexer = Fbtxt::Lexer.new( txt )
tokens, errors = lexer.tokenize_with_errors


# -or-  Fbtxt public (porcelain) api

result = Fbtxt.parse( txt )    # result is ParserResult w/ tree, errors, ok?/nok?, etc.
result =  Fbtxt.lex( txt )     # result is LexerResult w/ tokens, errors, ok?/nok?, etc
```




## document matcher reader (& football.txt to .json convert)

**fbtxt-document**   (last updated in may 2026!)

depends on: fbtxt-parser, season-formats

usage:

``` ruby
doc =  Fbtxt::Document.read( path )
doc  = Fbtxt::Document.parse( txt )

# returns Fbtxt::Document
##   incl. matches - array with struct Match   (SportDb::MatchTree:Match) and more

# -or-

doc = FbTxt::Document.new( txt )

doc.matches
doc.title   # aka league name
doc.errors? & doc.errors
```


## todo
##  add "downstream"   commandline tools with dependencies !!!


**fbtok/fbtree (& fbquick/fbquik/fbx)**   (last updated in may 2026!)
depends-on:
- fbtxt-parser      (fbtok/fbtree)
- fbtxt-document    (fbquick/fbquick/fbx)


**fbtxt2json/fbtxt2csv**      (last updated in may 2026!)
depends-on:
- fbtok  (incl. fbtxt-parser & fbtxt-document)


**footty**     (last updated in may 2026!)
depends-on:
- fbtxt-document   (incl. fbtxt-parser, season-formats)
- webget






### more

**fbup**
depends-on:
- gitti
- leagues         -- depends on: cocos, seasons-formats, tzinfo
- sportdb-writers -- depends on: sportdb-structs
