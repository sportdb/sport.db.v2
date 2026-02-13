#######
# test search (struct convenience) helpers/methods

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


## our own code
require 'sportdb/quick'


txt = <<TXT

## check "vanilla" score 
Tue Feb 13
  20.45  Juventus             1-2  Tottenham Hotspur   


## check match with match header
##   note - match line with header allows 
##     - no "inline" date & time 
##     - no date & time inheritance  (reset running last_date/time to nil)    
Tue Feb 13 20.45 @ Juventus Stadium, Turin
     Juventus             1-2  Tottenham Hotspur   


## Tue Feb 13
     Juventus             1-2  Tottenham Hotspur   


TXT

puts txt
puts


SportDb::MatchParser.debug = true
SportDb::MatchTree.debug = true


start = Date.new( 2024, 6, 1 )
parser = SportDb::MatchParser.new( txt, start: start )
pp parser

teams, matches, rounds, groups = parser.parse

pp [teams, matches, rounds, groups]

puts
puts "  try json for matches:"

data = matches.map {|match| match.as_json }
pp data

puts "bye"