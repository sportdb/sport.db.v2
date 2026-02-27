####
#  to run use:
#    $ ruby ./main_table.rb         (in /fbtxt)


##
##  check table (standing) lines

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

                      P  W  D  L   Gls  Pts
  1.BRAZIL            3  2  1  0   7- 2   7
  2.MEXICO            3  2  1  0   4- 1   7
  3.Croatia           3  1  0  2   6- 6   3
  4.Cameroon          3  0  0  3   1- 9   0 

 1.CANADA       14  8  4  2 23- 7 28 
 2.MEXICO       14  8  4  2 17- 8 28 
 3.USA          14  7  4  3 21-10 25
 4.Costa Rica   14  7  4  3 13- 8 25  Playoff 
 5.Panama       14  6  3  5 17-19 21 
 6.Jamaica      14  2  5  7 12-22 11 
 7.El Salvador  14  2  4  8  8-18 10 
 8.Honduras     14  0  4 10  7-26  4 



 1.SOLOMON I.    1  1  0  0  3- 1  3
 2.TAHITI        1  0  0  1  1- 3  0
 -.Cook Islands  withdrew after first match (annulled) due to Covid-19 outbreak in squad
 -.Vanuatu       withdrew before playing any matches due to Covid-19 outbreak in squad 


 1.HAITI         3  3  0  0 13- 0  9 
 2.Nicaragua     3  2  0  1 10- 1  6 
 3.Belize        3  1  0  2  5- 5  3 
 4.Turks/Caicos  3  0  0  3  0-22  0 
 -.Saint Lucia   withdrew  


 ##
 ## todo - how to deal with/support multi-line table notes!!!??? 
 ##
 ##   support "generic"  line-continuation \  - why? why not?
 ##
 ##  todo - add yaml like continuation via block indent - why? why not?

 1.SOUTH KOREA   6  5  1  0 22- 1 16  [0-0]
 2.LEBANON       6  3  1  2 11- 8 10  [0-2, 0-0]
 3.Turkmenistan  6  3  0  3  8-11  9  [3-1]
 4.Sri Lanka     6  0  0  6  2-23  0  [0-1]
 -.North Korea   withdrew after playing 5 matches due to safety concerns in \\
                 connection with the Covid-19 pandemic; all results annulled
NB: annulled results against North Korea between square brackets  

        

  1. ARG^         3  6  3 0 0    10-4
  2. CHI          3  4  2 0 1     5-3
  3. FRA          3  2  1 0 2     4-3
  4. MEX          3  0  0 0 3     4-13

 
###
##  try non-match notes
##   todo/fix
##   change []-style notes to match notes (only) - why? why not?
##
##  use NB: / NOTE:  for "generic" notes NOT attached to matches


  NB: Wales, Poland and Portugal qualified

NB: 5th placed team qualify for playoff against AFC 5th placed team (Australia)

 NB  : Senegal, Cameroon, Ghana, Morocco and Tunisia qualified


NOTE: the first stage also served as qualifying stage for the 2023 Asian Cup
     (with the losers being eliminated)

NB: the second stage also served as qualifying stage for the 2023 Asian Cup
    (with the group winners and five best runners-up qualifying for the final tournament and the
    other teams entering the qualifying tournament at various stages (remaining runners-up, third
    placed teams, fourth placed teams and three best fifth placed teams at group stage, 
    the others entering a playoff round)


NOTE   :  annulled results against North Korea between square brackets  


NB: Group winners and the five best runners-up teams qualified for third round.
    Qatar (first placed team) did not participate to third round.
    The same teams (including Qatar) qualified to 2023 Asian Cup.

NB: Australia qualify for playoff against 5th placed team in South America (Peru)
 

NB: Australia qualified

NB: New Zealand qualify for playoff against 4th placed team in CONCACAF (Costa Rica)





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