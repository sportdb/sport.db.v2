####
#  to run use:
#    $ ruby ./main_header.rb         (in /fbtxt)


##
##  check match headers 

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

July 10 @ Paris, Parc des Princes,   att: 18000    
Soviet Union     2-1  Yugoslavia      (aet)


▪ Final 
July 10 @ Paris, Parc des Princes    att: 18_000    
Soviet Union     2-1  Yugoslavia      (aet)
  (Metreveli 49, Ponedelnik 114; Galic 41)



## check for extended geo names
##    e.g. Dublin (Dalymount Park)

▪ Qualifying Round
05.04.1959 @ Dublin (Dalymount Park)  
Ireland           2-0  Czechoslovakia

21.06.1959 @ Ost-Berlin (Walter-Ulbricht)
East Germany      0-2  Portugal

01.10.1958 @ Paris (Parc des Princes)
France            7-1  Greece

02.11.1958 @ Bucuresti (23 August)
Romania           3-0  Turkey

03.12.1958 @ Athinai (OAKA - Maroussi)
Greece            1-1  France


###
#  check (inline) geo 

25.03.23 @ Glasgow        Scotland           3-0 Cyprus
25.03.23 @ Málaga         Spain              3-0 Norway
28.03.23 @ Batumi         Georgia            1-1 Norway
28.03.23 @ Glasgow        Scotland           2-0 Spain

###
#  todo/fix - allow match line starting w/ geo too - why? why not?
#  @ Glasgow        Scotland           3-0 Cyprus
#  @ Málaga         Spain              3-0 Norway
#  @ Batumi         Georgia            1-1 Norway
#  @ Glasgow        Scotland           2-0 Spain


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