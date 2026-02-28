####
#  to run use:
#    $ ruby ./main_goals_alt.rb         (in /fbtxt)


##
##  check (alternate)  goal lines 

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT


        (1-0 Franck Ribéry, 2-0 Ivica Olić, 2-1 Wayne Rooney)
      
        (1-0 Franck Ribéry, 
         2-0 Ivica Olić, 
         2-1 Wayne Rooney)

        (1-0 Franck Ribéry 2', 2-0 Ivica Olić 77', 2-1 Wayne Rooney 90+2')
        (1-0 Franck Ribéry 2, 2-0 Ivica Olić 77, 2-1 Wayne Rooney 90+2)
 
        (1-0 Franck Ribéry 2' 2-0 Ivica Olić 77' 2-1 Wayne Rooney 90+2')
        (1-0 Franck Ribéry 2  2-0 Ivica Olić 77  2-1 Wayne Rooney 90+2)
       
        (1-0 Franck Ribéry 2', 2-0 Ivica Olić 77', 
         2-1 Wayne Rooney)

         
  (1-0 Messi     23'(p), 
   2-0 Di María  36',
   2-1 Mbappé    80'(p),
   2-2 Mbappé    81', 
   3-2 Messi    108', 
   3-3 Mbappé   118'(p))

  (1-0 Messi     23p, 
   2-0 Di María  36,
   2-1 Mbappé    80p,
   2-2 Mbappé    81, 
   3-2 Messi    108, 
   3-3 Mbappé   118p)

  (1-0 Messi  2-0 Di María  2-1 Mbappé  2-2 Mbappé  3-2 Messi  3-3 Mbappé)
  (1-0 Messi 2-0 Di María 2-1 Mbappé 2-2 Mbappé 3-2 Messi 3-3 Mbappé)
  (1-0 Messi, 2-0 Di María, 2-1 Mbappé, 
   2-2 Mbappé, 3-2 Messi, 3-3 Mbappé)

  (1-0 Messi     23'(pen.), 
   2-0 Di María  36',
   2-1 Mbappé    80'(pen.),
   2-2 Mbappé    81', 
   3-2 Messi    108', 
   3-3 Mbappé   118'(pen.))

  (1-0 Messi    (p), 
   2-0 Di María,
   2-1 Mbappé  (p),
   2-2 Mbappé, 
   3-2 Messi, 
   3-3 Mbappé  (p))


 (0-1 Vujadinović 4, 1-1 Cea 19, 
  2-1 Anselmo 21 h,  3-1 Anselmo 23, 
  4-1 Iriarte 63,    5-1 Cea 66, 
  6-1 Cea 72)

   
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