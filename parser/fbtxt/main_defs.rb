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