#######
# test search (struct convenience) helpers/methods

require_relative 'helper'



OPENFOOTBALL_PATH = '../../../openfootball'

path =  "#{OPENFOOTBALL_PATH}/worldcup/2022--qatar/cup_finals.txt"

matches = SportDb::QuickMatchReader.read( path )
## pp matches

puts
puts "  try json for matches:"
data = matches.map {|match| match.as_json }
pp data

puts "bye"