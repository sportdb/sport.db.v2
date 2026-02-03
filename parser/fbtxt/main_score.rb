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

###
#  via wikipedia
#     https://en.wikipedia.org/wiki/2009–10_UEFA_Champions_League
#     https://en.wikipedia.org/wiki/2009–10_UEFA_Champions_League_knockout_phase

# Phase, Round, First leg + Second leg

# Qualifying, First qualifying round  |  30 June – 1 July 2009, 7–8 July 2009
# -,          Second qualifying round |  14–15 July 2009,  21–22 July 2009
# -,          Third qualifying round  |  28–29 July 2009, 4–5 August 2009
# Play-off,   Play-off round          |  18–19 August 2009, 25–26 August 2009
# Group stage,  Matchday 1            |  15–16 September 2009
# -,            Matchday 2            |  29–30 September 2009
# -,            Matchday 3            | 20–21 October 2009
# -,            Matchday 4            | 3–4 November 2009
# -,            Matchday 5            | 24–25 November 2009
# -,            Matchday 6            | 8–9 December 2009
# Knockout phase, Round of 16         | 16–17 & 23–24 February 2010, 9–10 & 16–17 March 2010
# -,              Quarter-finals      | 30–31 March 2010, 6–7 April 2010
# -,              Semi-finals         | 20–21 April 2010, 27–28 April 2010
# -,              Final               | 22 May 2010

# -or-

# First qualifying round, 1st leg   |	30.06/01.07.2009
# First qualifying round, 2nd leg   |	07/08.07.2009
# Second qualifying round, 1st leg  |	14/15.07.2009
# Second qualifying round, 2nd leg	| 21/22.07.2009
# Third qualifying round, 1st leg	  |	28/29.07.2009
# Third qualifying round, 2nd leg	  |	04/05.08.2009
# Play-off round, 1st leg	          |	18/19.08.2009
# Play-off round, 2nd leg	          |	25/26.08.2009
# Group stage, Matchday 1           |	15/16.09.2009
# Group stage, Matchday 2           | 29/30.09.2009
# Group stage, Matchday 3	          | 20/21.10.2009
# Group stage, Matchday 4	          | 03/04.11.2009
# Group stage, Matchday 5	          | 24/25.11.2009
# Group stage, Matchday 6	          | 08/09.12.2009
# First knockout round, 1st leg	    | 16/17 & 23/24.02.2010
# First knockout round, 2nd leg     | 09/10 & 16/17.03.2010
# Quarter-finals, 1st leg	          |	30/31.03.2010
# Quarter-finals, 2nd leg	          |	06/07.04.2010
# Semi-finals, 1st leg	            |	20/21.04.2010
# Semi-finals, 2nd leg	            |	27/28.04.2010
# Final                            	| 22.05.2010


# Times are CET/CEST, as listed by UEFA
#     (local times, if different, are in parentheses).

▪ Quarter-finals

March 30
  20:45   FC Bayern Munich (GER)  2-1  Manchester United F.C. (ENG)   @ Allianz Arena, Munich   #(att: 66000)
            (Franck Ribéry 77, Ivica Olić 90+2;
             Wayne Rooney 2)
April 7
   20:45 (19:45 BST/UTC+1)  Manchester United (ENG)  3-2  Bayern Munich (GER)  @ Old Trafford, Manchester   #(att: 74482)
               (Darron Gibson 3, Nani 7,41;
                Ivica Olić 43, Arjen Robben 74)
    # [4-4 on aggregate, win 1-2 on away goals]
     

March 31
   20:45  (19:45 BST/UTC+1) Arsenal F.C. (ENG)  2-2  FC Barcelona (ESP)  @ Emirates Stadium, London  #(att: 59572)
              (Theo Walcott 69, Cesc Fàbregas 85pen;
               Zlatan Ibrahimović 46,59)
April 6
   20:45      Barcelona (ESP)   4-1   Arsenal (ENG)  @ Camp Nou, Barcelona  #(att: 93330)
                (Lionel Messi 21,37,42,88;
                  Nicklas Bendtner 18)
    # [win 6-3 on aggregate]


▪ Final

May 22
   20:45   FC Bayern Munich (GER)  0-2  Inter Milan (ITA)  @ Santiago Bernabéu, Madrid  #(att: 73490)
               (Diego Milito 35,70)
             
               
##########
### try different style  with MatchHeader
###   only use country code e.g. (GER), (ENG) for first time

▪ Quarter-finals, 1st leg
March 30 20:45 @ Allianz Arena, Munich   #(att: 66000)
   Bayern Munich (GER)  2-1  Manchester United (ENG)   
      (Franck Ribéry 77, Ivica Olić 90+2;
       Wayne Rooney 2)
# March 31 20:45  (19:45 BST/UTC+1) 
March 31 20:45 @ Emirates Stadium, London  #(att: 59572)
   Arsenal FC (ENG)  2-2  FC Barcelona (ESP)  
      (Theo Walcott 69, Cesc Fàbregas 85pen;
      Zlatan Ibrahimović 46,59)

▪ Quarter-finals, 2nd leg
# April 7 20:45 (19:45 BST/UTC+1) 
April 6 20:45 @ Camp Nou, Barcelona  #(att: 93330)     
   FC Barcelona   4-1   Arsenal FC   (win 6-3 on aggregate)
      (Lionel Messi 21,37,42,88;
      Nicklas Bendtner 18)
April 7 20:45  @ Old Trafford, Manchester   #(att: 74482)
   Manchester United  3-2  Bayern Munich  (agg 4-4, win 1-2 on away goals)  
      (Darron Gibson 3, Nani 7,41;
       Ivica Olić 43, Arjen Robben 74)    
  
▪ Final
May 22 20:45 @ Santiago Bernabéu, Madrid  #(att: 73490)  
  FC Bayern Munich   0-2  Inter Milan   
      (Diego Milito 35,70)



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

###
#  via wikipedia
#      https://en.wikipedia.org/wiki/2011–12_UEFA_Champions_League
#      https://en.wikipedia.org/wiki/2011–12_UEFA_Champions_League_knockout_phase
#
#   Times are CET/CEST, as listed by UEFA 
#     (local times, if different, are in parentheses).


▪ Semi-finals 

April 17
   20:45   FC Bayern Munich (GER)  2-1  Real Madrid CF (ESP)  @ Allianz Arena, Munich  #(att: 66000)
             (Franck Ribéry 17, Mario Gómez 90;
              Mesut Özil 53)
April 25
   20:45   Real Madrid (ESP)   2-1 a.e.t., 1-3 pen.   Bayern Munich (GER)  @ Santiago Bernabéu, Madrid #(att: 71654)
            (Cristiano Ronald 6pen,14;
             Arjen Robben 27pen)
      # [3-3 on aggregate, win 1-3 on penalties]
      # [aet, 3-3 on aggregate, win 1-3 on penalties]

# |penalties1 =
# *[[Cristiano Ronaldo|Ronaldo]] {{penmiss}}
# *[[Kaká]] {{penmiss}}
# *[[Xabi Alonso|Alonso]] {{pengoal}}
# *[[Sergio Ramos|Ramos]] {{penmiss}}
# |penaltyscore = 1–3
# |penalties2 =
# *{{pengoal}} [[David Alaba|Alaba]]
# *{{pengoal}} [[Mario Gómez|Gómez]]
# *{{penmiss}} [[Toni Kroos|Kroos]]
# *{{penmiss}} [[Philipp Lahm|Lahm]]
# *{{pengoal}} [[Bastian Schweinsteiger|Schweinsteiger]]

April 18
  20:45 (19:45 UTC+1)  Chelsea F.C. (ENG)  1-0  FC Barcelona (ESP)   @ Stamford Bridge, London  #(att: 38039)
                        (Didier Drogba 45+2)                  
April 24
  20:45               Barcelona (ESP)   2-2     Chelsea (ENG)   @ Camp Nou, Barcelona  #(att: 95845)
                       (Sergio Busquets 35, Andrés Iniesta 43;
                        Ramires 45+1, Fernando Torres 90+1)
   # [win 2-3 on aggregate]

▪ Final

May 5
  20:45     FC Bayern Munich (GER)   1-1 a.e.t, 3-4 pen.  Chelsea F.C. (ENG)  @ Allianz Arena, Munich  #(att: 62500)
               (Thomas Müller 83; Didier Drogba 88)
                 
# |penalties1 =
# *[[Philipp Lahm|Lahm]] {{pengoal}}
# *[[Mario Gómez|Gómez]] {{pengoal}}
# *[[Manuel Neuer|Neuer]] {{pengoal}}
# *[[Ivica Olić|Olić]] {{penmiss}}
# *[[Bastian Schweinsteiger|Schweinsteiger]] {{penmiss}}
# |penaltyscore = 3–4
# |penalties2 =
# *{{penmiss}} [[Juan Mata|Mata]]
# *{{pengoal}} [[David Luiz]]
# *{{pengoal}} [[Frank Lampard|Lampard]]
# *{{pengoal}} [[Ashley Cole|Cole]]
# *{{pengoal}} [[Didier Drogba|Drogba]]






##########
### try different style


##  todo/fix
##     make header with geo its own production/parser rule
##               only can use once
##           change to   MatchHeader from generic (reuseable) DateHeader!!!

▪ Semi-finals, 1st leg
April 17 20:45   @ Allianz Arena, Munich  #(att: 66000)
  Bayern Munich (GER)  2-1  Real Madrid (ESP)  
             (Franck Ribéry 17, Mario Gómez 90;
              Mesut Özil 53)
##  April 18 20:45 (19:45 UTC+1)  -- fix - add time_with_timezone too -why? why not?
April 18 20:45 @ Stamford Bridge, London  #(att: 38039)
  Chelsea FC (ENG)  1-0  FC Barcelona (ESP)    
      (Didier Drogba 45+2)                  

▪ Semi-finals, 2nd leg
April 24 20:45 @ Camp Nou, Barcelona  #(att: 95845)              
    FC Barcelona         2-2  Chelsea FC  (win 2-3 on aggregate)
      (Sergio Busquets 35, Andrés Iniesta 43;
       Ramires 45+1, Fernando Torres 90+1)
April 25 20:45   @ Santiago Bernabéu, Madrid #(att: 71654)
   Real Madrid   2-1  Bayern Munich  (aet, 3-3 on agg, win 1-3 on pens)  
            (Cristiano Ronald 6pen,14;
             Arjen Robben 27pen)

▪ Final   
May 5 20:45 @ Allianz Arena, Munich  #(att: 62500)     
    FC Bayern Munich    1-1 Chelsea FC  (aet, win 3-4 on pens) 
        (Thomas Müller 83; Didier Drogba 88)


## TODO
##  add rsssf  as a comment
##    uses (compact) "two-leg" style



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