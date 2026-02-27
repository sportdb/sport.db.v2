####
#  to run use:
#    $ ruby sandbox/test_goal_counts.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'




txt =<<TXT

(2)
(2/p)
(2/pen.)
(3/2p)
(3/ 2 pen.)

(2,1pen)
(3, 2 pens)

(p) 
(pen.) 
(2 pen.) 
(2p)
(2 pens)               

(o)
(og) 
(o.g.) 
(2og)
(2 o.g.)
(2 ogs)

TXT


txt.each_line do |line|
  line = line.strip
  next if line.empty? || line.start_with?('#')


  m= SportDb::Lexer::_parse_goal_count( line )
  ## pp m
 
  if m
    print "OK "
    print "%-20s" % line
    print "  => "
    puts m.inspect
  else
     puts "!! #{line}   -- text NOT matching"
  end
end


puts "bye"