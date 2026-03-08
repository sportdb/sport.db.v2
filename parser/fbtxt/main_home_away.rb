####
#  to run use:
#    $ ruby ./main_home_away.rb         (in /fbtxt)


$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

==Arsenal==     

Sun  1 Mar        (H)  Chelsea                    2-1
Wed  4 Mar        (A)  Brighton and Hove Albion   0-1
Sat 14 Mar 17:30  (H)  Everton
Sat 11 Apr 12:30  (H)  Bournemouth
Sun 19 Apr 16:30  (A)  Manchester City
Sat 25 Apr 17:30  (A)  Newcastle United

    
Sun 24 May 16:00  (N)  Crystal Palace



Su  1/3        (h)  Chelsea                    2-1
We  4/3        (a)  Brighton and Hove Albion   0-1
Sa 14/3 17:30  (h)  Everton
Sa 11/4 12:30  (h)  Bournemouth
Su 19/4 16:30  (a)  Manchester City
Sa 25/4 17:30  (a)  Newcastle United

    
Su 24/5 16:00  (n)  Crystal Palace



#########
## check minimal versions (no date, no score)

(h)  Chelsea                    2-1
(a)  Brighton and Hove Albion   0-1
(h)  Everton
(h)  Bournemouth
(a)  Manchester City
(a)  Newcastle United

 


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