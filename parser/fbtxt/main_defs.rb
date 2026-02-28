####
#  to run use:
#    $ ruby ./main_defs.rb         (in /fbtxt)


##
##  check definition lines  (groups, rounds/matchdays, etc.)

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

▪ Final | July 10 
▪ Final: July 10 
▪ Final : July 10 

Group A  |  Brazil       Croatia              Mexico         Cameroon
Group B  |  Spain        Netherlands          Chile          Australia
Group C  |  Colombia     Greece               Côte d'Ivoire  Japan
Group D  |  Uruguay      Costa Rica           England        Italy
Group E  |  Switzerland  Ecuador              France         Honduras
Group F  |  Argentina    Bosnia-Herzegovina   Iran           Nigeria
Group G  |  Germany      Portugal             Ghana          United States
Group H  |  Belgium      Algeria              Russia         South Korea


Group A:  Brazil,  Croatia,   Mexico,   Cameroon
Group A:  Brazil       Croatia              Mexico         Cameroon
Group A  :  Brazil       Croatia              Mexico         Cameroon


▪ Matchday 1  
▪ Matchday 2  
▪ Matchday 3  

▪ Matchday 1  |  Thu Jun 12
▪ Matchday 2  |  Fri Jun 13
▪ Matchday 3  |  Sat Jun 14
▪ Matchday 10 |  Sat Jun 21
▪ Matchday 11 |  Sun Jun 22
▪ Matchday 12 |  Mon Jun 23
▪ Matchday 13 |  Tue Jun 24
▪ Matchday 14 |  Wed Jun 25

▪ Matchday 1:  Thu Jun 12
▪ Matchday 2  :  Fri Jun 13
▪ Matchday 3  :  Sat Jun 14
▪ Matchday 10 :  Sat Jun 21
▪ Matchday 11 :  Sun Jun 22
▪ Matchday 12 :  Mon Jun 23
▪ Matchday 13 :  Tue Jun 24
▪ Matchday 14:   Wed Jun 25


Group 1  |   Brazil   Mexico   Switzerland    Yugoslavia
Group 2  |   England  Chile    Spain          United States
Group 3  |   Italy    India    Paraguay       Sweden
Group 4  |   Uruguay  Bolivia  France

▪ First round | June 24 - July 2
▪ Final Round | July 9-16

▪ First round : June 24 - July 2
▪ Final Round : July 9-16


## check match schedule with rounds
##    todo - add support for date list (more than one date or duration!!!)

▪ Round 19 | Mar 31/Apr 1
▪ Round 20 | Apr 6-8, Apr 24              ## or Apr 6-8, 24 ???
▪ Round 21 | Apr 14-16, Apr 24, May 8
▪ Round 22 | Apr 21/22, Apr 24, May 29    ## or Apr 21&22 or 21+22
▪ Round 23 | Apr 28
▪ Round 24 | May 1
▪ Round 25 | May 4-6
▪ Round 26 | May 10-13
▪ Round 27 | May 18-20
▪ Round 28 | May 23/24
▪ Round 29 | May 26/27                   ## May 26,27 ??
▪ Round 30 | May 31-Jun 2

## mark out of order dates in rounds - why? why not?
##   e.g.   ca. Apr 18  
▪ Round 19  | Mar 24/25,  ca. Apr 18


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