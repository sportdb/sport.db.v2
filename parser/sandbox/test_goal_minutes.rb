####
#  to run use:
#    $ ruby sandbox/test_goal_minutes.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'




txt =<<TXT

 24'
 24'
 45'+1
 45+1'
 45'+1'
 111'
 119
 120'+8

## try classic goal types
 24'p
 24 p
 24'pen
 24(p)
 24(pen)
 24(pen.)
 24og
 24o.g.
 24(og)
 24(o.g.)
 24o
 24 o

 90'+1 (pen)
 90+1' (pen)
 90'+1' (pen.)


## try h(eader) goal type (goal scored with head)
 24' h
 24 h
 24h
 24(h)
 ## try f(ree kick) goal type
24' f
24 f
24f
24(f)

## try "turbo" record goals in seconds
 2 (98 secs)
 2 (98sec)
 2 (111secs)


### allow 46+  for 45+1 - why? why not?
##        94+  for 90+1  
  46+
  94+
  46'+
  94'+
  102+


  94+ (pen)
  46+ og
  
  94'+ (pen)
  90'+4 (pen)
  103'+ (pen)
  46'+ f
  45'+1 f
  122'+
  120'+2
TXT


txt.each_line do |line|
  line = line.strip
  next if line.empty? || line.start_with?('#')


  m= SportDb::Lexer::_parse_goal_minute( line )
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