
## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../document/lib' ))


## our own code
require 'fbtxt/parser'
require 'fbtxt/document'


OPENFOOTBALL_PATH = '/sports/openfootball'


Fbtxt::MatchTree.debug = false
Fbtxt::Document.debug  = false
