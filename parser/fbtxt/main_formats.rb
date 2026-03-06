####
#  to run use:
#    $ ruby ./main_formats.rb         (in /fbtxt)


##
##  check different match formats/styles

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

###
##  check for 04/03/2026 date 
##      and     19h30 time style 
##      and      vs. match separator (vs. NOT recommended, use simply v !!!)

04/03/2026 19h30  Brighton & Hove Albion FC vs. Arsenal FC 
04/03/2026 18h00  Rayo Vallecano de Madrid vs. Real Oviedo
04/03/2026 19h30  Hamburger SV vs. Bayer 04 Leverkusen 
04/03/2026 19h30  Manchester City FC vs. Nottingham Forest FC 
04/03/2026 19h30  Aston Villa FC vs. Chelsea FC 
04/03/2026 19h30  Fulham FC vs. West Ham United FC 
04/03/2026 20h15  Newcastle United FC vs. Manchester United FC 



= 1. Fußball-Bundesliga 2025/2026
          ▪ 1. Spieltag
22.08.25 20:30  FC Bayern München - RB Leipzig
23.08.25 15:30  1. FC Union Berlin - VfB Stuttgart
23.08.25 15:30  SC Freiburg - FC Augsburg
23.08.25 15:30  1. FC Heidenheim 1846 - VfL Wolfsburg
23.08.25 15:30  Eintracht Frankfurt - SV Werder Bremen
23.08.25 15:30  Bayer 04 Leverkusen - TSG Hoffenheim
23.08.25 18:30  FC St. Pauli - Borussia Dortmund
24.08.25 15:30  1. FSV Mainz 05 - 1. FC Köln
24.08.25 17:30  Borussia Mönchengladbach - Hamburger SV


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