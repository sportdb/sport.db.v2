####
#  to run use:
#    $ ruby ./main_err.rb  (in /fbtxt)


=begin


fix - check why [] !!!! possible?   

 [:TEAM, "France"],
 [:"@"],
 [:GEO, "Arena Amazônia"],
 [:","],
 [:GEO, "Manaus"],
 [:TIMEZONE, "(UTC-4)"]]
[[:BLANK, "<|BLANK|>"]]
[]
[[:SCORE, ["20-21", {:ft=>[20, 21]}]]]
[[:BLANK, "<|BLANK|>"]]
[[:BLANK, "<|BLANK|>"]]
[[:TEAM, "Denmark"],
 [:SCORE, ["2-2", {:ft=>[2, 2]}]],
 [:TEAM, "France"],
=end


## try error handling


$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT
################
#### more       
Rapid Wien   0-1  Austria Wien
Rapid Wien   0-2  Austria Wien    [awarded]

Rapid Wien v Austria Wien
Rapid Wien v Austria Wien 0-3   [awarded]
Rapid Wien v Austria Wien 0-4     @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien v Austria Wien   [cancelled]   @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien - Austria Wien    
Rapid Wien - Austria Wien 1-5   [awarded]
Rapid Wien - Austria Wien 1-6     @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien - Austria Wien   [cancelled]   @ Gerhard-Hanappi-Stadion, Wien



###
#  try geo with timezone

## add errors here
   : : :  some text here     ## gets handled by tokenizer!!!
11-12
13-14

## another line here
   ! ! !  more text here   ## gets handled by tokenizer!!!
15-17

 Denmark  0-0  France   @ Arena Amazônia, Manaus  
 Denmark  1-1  France   @ Arena Amazônia, Manaus (UTC-4)
 
## more here
   $$$     ## gets handled by tokenizer!!!
20-21
 

 Denmark  2-2  France   @ Arena Amazônia (UTC-4)
 Denmark  3-3  France   @ Manaus (UTC-4)

## try more errors
 @  Bamberg, Oberfranken, Bayern

 Denmark v France   @ Manaus (UTC-4)

TXT



  parser = RaccMatchParser.new( txt, debug: true )
  tree, errors = parser.parse_with_errors
  puts "-- tree:"
  pp tree
  puts "-- errors:"
  pp errors


if parser.errors?
  puts "-- #{parser.errors.size} parse error(s)"
  pp parser.errors
else
  puts "--  OK - no parse errors found"
end

puts "bye"

