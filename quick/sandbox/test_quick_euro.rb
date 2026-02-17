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


## SportDb::MatchParser.debug = true
SportDb::MatchParser.debug = true
SportDb::QuickMatchReader.debug = true


## path =  "#{OPENFOOTBALL_PATH}/euro/2024--germany/euro.txt"
## path =  "#{OPENFOOTBALL_PATH}/euro/2028--united_kingdom-ireland/euro.txt"

##  check for time_local e.g.   18:00 (17:00 UTC+1)
##    [:TIME,       ["18:00",         {:h=>18, :m=>0}]]
##    [:TIME_LOCAL, ["(17:00 UTC+1)", {:h=>17, :m=>0, :timezone=>"UTC+1"}]]
##                              21:00 (20:00 UTC+1) 
##    [:TIME,       ["21:00",         {:h=>21, :m=>0} ]]
##    [:TIME_LOCAL, ["(20:00 UTC+1)", {:h=>20, :m=>0, :timezone=>"UTC+1"} ]]
##   
path =  "#{OPENFOOTBALL_PATH}/euro/2021--europe/euro.txt"

matches = SportDb::QuickMatchReader.read( path )
## pp matches

puts
puts "  try json for matches:"
data = matches.map {|match| match.as_json }
pp data

puts "bye"