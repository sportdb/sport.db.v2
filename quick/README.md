# fbtxt-document - football.txt match readers (incl. Fbtxt::Document) and more



## Usage


``` ruby
require 'fbtxt/document'


# path = "./euro/2024--germany/euro.txt"
path =  "./deutschland/2024-25/1-bundesliga.txt"

doc = Fbtxt::Document.read( path )
pp doc

#  try json for matches
data = doc.matches.map {|match| match.as_json }
pp data
```
