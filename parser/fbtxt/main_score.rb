####
#  to run use:
#    $ ruby ./main_score.rb  (in /fbtxt)


##
##  check some fuller scores with on aggregate and on away goals etc.


$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT


###
##  check round outlines with different round markers

######
## champs 2009/10

▪ Quarter-finals - 1st Leg
Mar 30
  Bayern München (Ger) 2-1 Manchester United (Eng)
Mar 31
  Arsenal (Eng) 2-2 Barcelona (Spa)

▪ Quarter-finals - 2nd Leg
Apr 6
  Barcelona 4-1 Arsenal   (6-3 on agg)
Apr 7
  Manchester United 3-2 Bayern München  (agg 4-4, win 1-2 on away goals)


Bayern München 2-1 Manchester United  (HT 0-1)
Arsenal 2-2 Barcelona  (HT 0-0)
Barcelona 4-1 Arsenal  (HT 3-1, AGG 6-3)
Manchester United 3-2 Bayern München  (HT 3-1, AGG 4-4, AWAY 1-2)


#######
## champs 2011/12

▪ Semi-finals - 1st Leg
Apr 17
   Bayern München 2-1 Real Madrid
Apr 18
  Chelsea 1-0 Barcelona

▪ Semi-finals - 2nd Leg
Apr 24
  Barcelona 2-2 Chelsea  (win 2-3 on aggregate)
Apr 25
  Real Madrid 2-1 Bayern München  (aet, agg 3-3, win 1-3 on pens)


#########  
###  with (all) half-time, full-time (90min) scores

Bayern München 2-1 Real Madrid  (HT 1-0)
Chelsea 1-0 Barcelona  (HT 1-0)
Barcelona 2-2 Chelsea  (HT 2-1, AGG 2-3)
Real Madrid 2-1 Bayern München  (HT 2-1, FT 2-1, AET, AGG 3-3, PEN 1-3)



#######
## champs 2012/13

▪ Final
May 19 @ Allianz Arena, München
  Bayern München 1-1 Chelsea (aet, win 3-4 on pens)

Bayern München 1-1 Chelsea (HT 0-0, FT 1-1, AET, PEN 3-4)

Bayern München v Chelsea  1-1 aet (1-1, 0-0) 3-4 pen
Bayern München v Chelsea  1-1 aet, 3-4 pen
Bayern München v Chelsea  3-4 pen (1-1, 1-1, 0-0) 
Bayern München v Chelsea  3-4 pen 1-1 aet (1-1, 0-0)
Bayern München v Chelsea  3-4 pen 1-1 aet

Bayern München  1-1 aet (1-1, 0-0) 3-4 pen  Chelsea 
Bayern München  1-1 aet, 3-4 pen  Chelsea 
Bayern München  3-4 pen (1-1, 1-1, 0-0)  Chelsea  
Bayern München   3-4 pen 1-1 aet (1-1, 0-0)  Chelsea 
Bayern München   3-4 pen. 1-1 a.e.t.   Chelsea 



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