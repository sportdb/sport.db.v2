####
#  to run use:
#    $ ruby ./main_ord.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

▪ Round of 16
June 24
  (37)  Winner Group A   v Runner-up Group C   @ Cardiff
  (38)  Runner-up Group A v Runner-up Group B   @ Liverpool



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