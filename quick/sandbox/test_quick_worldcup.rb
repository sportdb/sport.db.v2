#######
# test search (struct convenience) helpers/methods

require_relative 'helper'



OPENFOOTBALL_PATH = '../../../openfootball'

path =  "#{OPENFOOTBALL_PATH}/worldcup/2022--qatar/cup_finals.txt"

doc = Fbtxt::Document.read( path )

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data


puts
puts "---"
pp doc



puts "bye"