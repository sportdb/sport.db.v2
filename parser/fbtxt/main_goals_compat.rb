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


(19' 0-1  Sandor
 40' 1-1  Mascaranha
 45' 2-1  Figueiredo
 73' 2-2  Kuti
 75' 2-3  Sandor
 80' 3-3  Figueiredo)

(19 0-1  Sandor
 40 1-1  Mascaranha
 45 2-1  Figueiredo
 73 2-2  Kuti
 75 2-3  Sandor
 80 3-3  Figueiredo)


(19'             0-1  Sandor
 40'  Mascaranha 1-1   
 45'  Figueiredo 2-1  
 73'             2-2 Kuti  
 75'             2-3 Sandor
 80'  Figueiredo 3-3)



(19' 1-0  Morais)


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