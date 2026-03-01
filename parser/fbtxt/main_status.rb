####
#  to run use:
#    $ ruby ./main_status.rb         (in /fbtxt)


##
##  check lines w/ inline match status  e.g. n/p, w/o, bye  
##                 or match status notes e.g. [cancelled], [annulled], etc.

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

SW Bregenz      3-0 Liefering        [awarded; abandoned at 2-0 in injury time,
                                        Liefering walked off]

SW Bregenz      3-0 awd Liefering      
SW Bregenz      3-0awd Liefering      
SW Bregenz      3-0awd. Liefering      

SW Bregenz 0-1 awd Liefering      
SW Bregenz 0-1awd Liefering      
SW Bregenz 0-1awd. Liefering      
SW Bregenz 0-1 awd. Liefering      


Schwarz-Weiß     1-4 Austria W             [annulled]


TuS St. Peter/Ottersbach      n/p SV Rohrbach
UFC Fehring                   n/p SC Weiz 
SV Klöch                      n/p SV Frohnleiten
SC Parschlug                  n/p FC Judenburg
SV Frauental                  n/p Deutschlandsberger SC 


SC Parschlug n/p FC Judenburg
SV Frauental n/p Deutschlandsberger SC 


##########
## check (inline) bye

Chichester City     bye      
Chichester City         bye        [Bury bankrupted]     


Chichester City bye      


###########
### check (inline) w/o

  Sheffield Wednesday     w/o Bury 
  Sheffield Wednesday     w/o Bury   [Bury bankrupted]

  Altrincham    w/o Gateshead  
  Altrincham    w/o Gateshead  [Gateshead not admitted due to not meeting 
                                ground ownership requirements; 
                                match not fixtured]    

  Altrincham w/o Gateshead  
  Sheffield Wednesday w/o Bury 


###
##  check (inline)  abd/abd.  (abandoned)

  Liefering        abd Juniors OÖ       [abandoned at 0-0 in 15' due to heavy snowfall]
  Amstetten        abd BW Linz          [abandoned at 0-1 in 37' due to heavy snowfall]

  Liefering        abd Juniors OÖ 
  Amstetten        abd BW Linz        

  Liefering        abd. Juniors OÖ 
  Amstetten        abd. BW Linz        

  Liefering abd Juniors OÖ 
  Amstetten abd BW Linz        
  Liefering abd. Juniors OÖ 
  Amstetten abd. BW Linz        
 

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