#######
# test search (struct convenience) helpers/methods

require_relative 'helper'


OPENFOOTBALL_PATH = '../../../openfootball'



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


doc = Fbtxt::Document.read( path )

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data

puts
puts "---"
pp doc


puts "bye"
