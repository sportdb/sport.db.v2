####
#  to run use:
#    $ ruby ./main_note.rb         (in /fbtxt)


##
##  check lines w/ notes

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT
▪ Round 18
Mar 1
  SW Bregenz      3-0 Liefering        [awarded; abandoned at 2-0 in injury time,
                                        Liefering walked off]

▪ Round 9
Aug 26
Schwarz-Weiß     1-4 Austria W             [annulled]
  [to be replayed - Mayrleb's first goal scored after Schwarz-Weiß had
   conceded Austria throw-in in order to have injured player treated]


▪ Round 29
Apr 14
Rapid            1-1 GAK
  (Wallner 62; Tutu 72)
  [protest Rapid as referee disallowed a 45' goal by Wallner (Rapid) after the 
   break, restarting the match with a referee's ball rather than the second half
   kick-off (officially the match was interrupted until the re-start rather than
   a break having been held); the GAK defenders had stopped playing before the 
   goal because of a whistle from the stands which they believed to come from 
   the referee (for off-side - which would probably have been the correct
   decision in any case); Rapid want a replay of the 2nd half starting at 1-0;
   then GAK have requested a replay (one assumes from scratch); after the result
   was already confirmed by 2 instances, Rapid withdrew the protest on May 22,
   by which time it had become pointless, as Tirol were mathematically champions
   irrespective of this result]


#####
##  check inline notes

Chichester City         bye      
Chichester City         bye        [Bury bankrupted]     

▪ Round 1
  Sheffield Wednesday     w/o Bury 
  Sheffield Wednesday     w/o Bury   [Bury bankrupted]

▪ National League, Promotion Playoff, Round 1
  Altrincham    w/o Gateshead  
  Altrincham    w/o Gateshead  [Gateshead not admitted due to not meeting 
                                ground ownership requirements; 
                                match not fixtured]    


▪ 1st Round                                              
Nov 11  
  Crystal Palace      0-0  Hitchin            [both qualified]
▪ Quarter-finals
Jan 20  
  Wanderers           0-0  Crystal Palace      [both qualified]


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