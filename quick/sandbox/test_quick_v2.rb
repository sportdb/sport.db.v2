#######
# test search (struct convenience) helpers/methods

require_relative 'helper'



OPENFOOTBALL_PATH = '/sports/openfootball'



path =  "#{OPENFOOTBALL_PATH}/world/pacific/australia/2023-24_au1.txt"

matches = SportDb::QuickMatchReader.read( path )
## pp matches

puts
puts "  try json for matches:"
data = matches.map {|match| match.as_json }
pp data

puts "bye"