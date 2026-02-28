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


###
#  check rulers/divider lines in tables

 1.FC Kärnten                   36 21  7  8 71-34  70  Promoted
-----------------------------------------------------
 2.BSV Bad Bleiberg             36 20  8  8 71-42  68
 3.SC Untersiebenbrunn          36 17  6 13 61-56  57
 4.DSV Leoben                   36 15  9 12 59-45  54
 5.SC Austria Lustenau          36 15  4 17 58-55  49
 6.SV Wörgl                     36 11 12 13 58-69  45
 7.SV Mattersburg               36 11  9 16 52-67  42
 8.SV Braunau                   36 10 11 15 46-67  41
- - - - - - - - - - - - - - - - - - - - - - - - - - -
 9.First Vienna FC              36 10  8 18 41-59  38  Relegation Playoff
-----------------------------------------------------
10.WSG Wattens                  36  8 10 18 39-62  34  Relegated


 1.SK Sturm Graz                22  14  4  4  51-28  46  [C]  [2 0 2 0 4-4 2]  Championship Playoff
 2.FK Austria Wien              22  14  4  4  36-19  46       [2 0 2 0 4-4 2]  Championship Playoff
 3.RB Salzburg                  22  10  8  4  33-22  38                        Championship Playoff
 4.Wolfsberger AC               22  11  3  8  44-30  36                        Championship Playoff
 5.SK Rapid Wien                22   9  7  6  32-24  34                        Championship Playoff
 6.FC Blau-Weiß Linz            22  10  3  9  30-29  33                        Championship Playoff
- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 7.LASK Linz                    22   9  4  9  32-33  31                        Relegation Playoff
 8.TSV Hartberg                 22   6  8  8  24-31  26                        Relegation Playoff
 9.SK Austria Klagenfurt        22   5  6 11  22-44  21                        Relegation Playoff
10.Wattener SG Tirol            22   4  7 11  20-31  19                        Relegation Playoff
11.GAK 1902                     22   3  7 12  27-45  16  [P]  [2 1 1 0 3-2 4]  Relegation Playoff
12.SC Rheindorf Altach          22   3  7 12  20-35  16       [2 0 1 1 2-3 1]  Relegation Playoff  -->

NB: teams carry over half their points from the regular stage (listed between
    square brackets), rounded downwards (marked by * where applicable) 


 1.SK Sturm Graz                32  19  6  7  66-39  40  [23]  [C]  Champions
 2.RB Salzburg                  32  16  9  7  53-36  38  [19]
 3.FK Austria Wien              32  18  6  8  47-32  37  [23]  [4 3 1 0 6-2 10]
 4.Wolfsberger AC               32  16  7  9  60-38  37  [18]  [4 0 1 3 2-6  1]
 5.SK Rapid Wien                32  12  8 12  43-42  27  [17]       Conference League Playoff
 6.FC Blau-Weiß Linz            32  11  5 16  37-45  21  [16*]

 7.LASK Linz                    32  16  6 10  51-36  38  [15*]      Conference League Playoff
 8.TSV Hartberg                 32  11 11 10  40-40  31  [13]       Conference League Playoff
 9.Wattener SG Tirol            32   7  9 16  35-50  20  [ 9*]
10.GAK 1902                     32   5 13 14  34-54  20  [ 8]  [P]
11.SC Rheindorf Altach          32   5 11 16  29-46  18  [ 8]
-------------------------------------------------------
12.SK Austria Klagenfurt        32   6  9 17  33-70  16  [10*]      Relegated

NB: teams carry over half their points from the regular stage (listed between
    square brackets), rounded downwards (marked by * where applicable) 


NB: between fifth placed club from the championship playoff and the
    top-2 of the relegation playoff  


 1. Pettenbach            30  19  5  6  85-44  62  promoted
-------------------------------------------------
 2. Micheldorf            30  18  7  5  74-38  61
 3. Sierning              30  16  8  6  60-40  56
 4. Freistadt             30  15  9  6  74-46  54
 5. Amateure Steyr        30  16  2 12  61-53  50
 6. SV Traun              30  14  5 11  65-64  47
 7. Königswiesen          30  13  4 13  62-69  43
 8. Ennser SK             30  10 10 10  44-56  40
 9. Naarn                 30  10  8 12  49-54  38
10. SC Marchtrenk         30  10  8 12  51-59  38
11. Pichling              30  10  6 14  47-58  36
12. Westbahn Linz         30   9  7 14  40-52  34
13. Nettingsdorf          30   6 10 14  31-49  28
14. Garsten               30   8  4 18  50-71  28
-------------------------------------------------
15. Gallneukirchen        30   8  3 19  48-72  27  relegated
16. Hörsching             30   6  8 16  36-52  26  relegated    


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