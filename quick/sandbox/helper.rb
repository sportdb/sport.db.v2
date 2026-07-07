## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


## our own code
require 'fbtxt/document'


## turn on debugging output
Fbtxt::MatchTree.debug = true
