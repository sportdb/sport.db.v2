#######
# test search (struct convenience) helpers/methods


require_relative 'helper'

OPENFOOTBALL_PATH = '../../../openfootball'




# path =  "#{OPENFOOTBALL_PATH}/champions-league/2024-25/cl.txt"
path =  "#{OPENFOOTBALL_PATH}/champions-league/2022-23/cl.txt"

doc = Fbtxt::Document.read( path )

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data

puts
puts "---"
pp doc

puts "bye"