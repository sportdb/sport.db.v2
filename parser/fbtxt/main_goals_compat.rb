####
#  to run use:
#    $ ruby ./main_goals_compat.rb         (in /fbtxt)


##
##  check (alternate) compat(ibility) "legacy"  goal lines 
##        starting with minutes


$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

(6' Puskás 0-1, 9' Czibor 0-2, 11' Morlock 1-2, 18' Rahn 2-2,
  84' Rahn 3-2)
(6 Puskás 0-1, 9 Czibor 0-2, 11 Morlock 1-2, 18 Rahn 2-2,
  84 Rahn 3-2)


(6' Puskás  0-1
 9' Czibor  0-2
11' Morlock 1-2
18' Rahn    2-2
84' Rahn    3-2)

(6 Puskás  0-1
 9 Czibor  0-2
11 Morlock 1-2
18 Rahn    2-2
84 Rahn    3-2)



TXT


  parser = RaccMatchParser.new( txt, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end
  


puts "bye"