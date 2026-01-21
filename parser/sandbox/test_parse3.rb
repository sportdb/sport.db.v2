####
#  to run use:
#    $ ruby sandbox/test_parse3.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



txt = <<TXT


Tue Feb/13
  20.45  Juventus             2-2  Tottenham Hotspur    @ Juventus Stadium, Turin
           (Higuaín 2', 9' (pen.); Kane 35' Eriksen 71')
  20.45  Basel                0-4  Manchester City      @ St. Jakob-Park, Basel
           (-; Gündoğan 14', 53' B. Silva 18' Agüero 23')

Wed Feb/14
  20.45  Porto                v Liverpool  0-5            @ Estádio do Dragão, Porto
           (-; Mané 25', 53', 85' Salah 29' Firmino 69')
  20.45  Real Madrid          v Paris Saint-Germain  3-1  @ Santiago Bernabéu, Madrid
           (Ronaldo 45' (pen.), 83' Marcelo 86'; 
            Rabiot 33')

Tue Feb/20
  20.45  Bayern München       5-0  Beşiktaş             @ Allianz Arena, München
           (Müller 43', 66' Coman 53' Lewandowski 79', 88')
  20.45  Chelsea              1-1  Barcelona            @ Stamford Bridge, London
           (Willian 62'; Messi 75')

##  check for goal scorer line inline (note - NOT ALLOWED for now)
##  20.45  Manchester City      1-2  Liverpool      (Gabriel Jesus 2'; Salah 56' Firmino 77')

TXT

puts txt
puts


parser = RaccMatchParser.new( txt )

tree = parser.parse

puts
puts "(parse) tree:"
pp tree

puts "bye"
