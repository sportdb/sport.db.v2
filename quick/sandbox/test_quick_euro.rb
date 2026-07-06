#######
# test search (struct convenience) helpers/methods

require_relative 'helper'



OPENFOOTBALL_PATH = '../../../openfootball'


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

doc = Fbtxt::Document.read( path )
## pp doc.matches

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data


puts
puts "---"
pp doc


puts "bye"