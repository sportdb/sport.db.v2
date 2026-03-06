####
#  to run use:
#    $ ruby ./main_dates.rb         (in /fbtxt)


##
##  check different date formats

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

## with month (Jul/July)
July 10 
Jul 10
July 10 2026
Fri July 10
Fri July 10 2026
Friday July 10 2026
Fr July 10
Fr July 10 2026


10 July
10 Jul
10 July 2026
Fri 10 July
Fri 10 July 2026
Friday 10 July 2026
Fr 10 July
Fr 10 July 2026


###############
## all numbers
10.07.2026
10.7.2026
10.07.26
10.7.26
10.07.
10.7.
Fri 10.07.2026
Fr 10.7.2026
Fr 10.07.26
Fr 10.7.26
Fr 10.07.
Fr 10.7.


###
# iso style
2026-07-10 
2026-7-10

##  starting with day-month-year
07-10-2026
7-10-2026
Fri 07-10-2026
Fr 7-10-2026

###
#  use slash (/)
07/10/2026
7/10/2026
Fri 07/10/2026
Fr 7/10/2026




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