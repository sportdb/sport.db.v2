#######
# test search (struct convenience) helpers/methods

require_relative 'helper'

OPENFOOTBALL_PATH = '../../../openfootball'




# path = "#{OPENFOOTBALL_PATH}/euro/2024--germany/euro.txt"
path =  "#{OPENFOOTBALL_PATH}/deutschland/2024-25/1-bundesliga.txt"

doc = Fbtxt::Document.read( path )

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data


puts
puts "---"
pp doc


puts "bye"