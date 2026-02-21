#######
# test search (struct convenience) helpers/methods

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


## our own code
require 'sportdb/quick'


OPENFOOTBALL_PATH = '../../../openfootball'


SportDb::MatchTree.debug = true


# path =  "#{OPENFOOTBALL_PATH}/euro/rsssf/60e.txt"
# path =  "#{OPENFOOTBALL_PATH}/euro/rsssf/2024e.txt"
# path =  "#{OPENFOOTBALL_PATH}/england/rsssf/engcup1873.txt"
# path =  "#{OPENFOOTBALL_PATH}/england/rsssf/eng2025-premierleague.txt"
# path =  "#{OPENFOOTBALL_PATH}/england/rsssf/eng2024-playoffs.txt"
# path =  "#{OPENFOOTBALL_PATH}/deutschland/rsssf/duit64.txt"
# path =  "#{OPENFOOTBALL_PATH}/deutschland/rsssf/duit65.txt"
# path =  "#{OPENFOOTBALL_PATH}/deutschland/rsssf/duit2025.txt"
# path =  "#{OPENFOOTBALL_PATH}/austria/rsssf/oost2025.txt"
# path =  "#{OPENFOOTBALL_PATH}/austria/rsssf/oost2025_cup.txt"
path =  "#{OPENFOOTBALL_PATH}/austria/rsssf/oost01.txt"


matches = SportDb::QuickMatchReader.read( path )
## pp matches

puts
puts "  try json for matches:"
data = matches.map {|match| match.as_json }
pp data

puts "bye"

