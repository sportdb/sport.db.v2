# Notes on Gems

How-to Update the paser and quick parser gems



## "core" parser (& lexer)

**sportdb-parser**

depends on:  cocos



## "quick" matcher parser (& .txt to .json convert)

**sportdb-quick**

depends on: sportdb-parser, logutils


- SportDb::QuickMatchReader.read( path )
- SportDb::QuickMatchReader.parse( txt )

returns array of struct Match   (SportDb::MatchTree:Match)



## todo
##  add "downstream"   commandline tools with dependencies !!!

- fbtxt2json
- fbtxt2csv
- fbtok/fbtree ??
- footty