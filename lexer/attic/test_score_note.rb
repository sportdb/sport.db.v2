####
#  to run use:
#    $ ruby sandbox/test_score_note.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


SCORE_NOTE_RE  = SportDb::Lexer::SCORE_NOTE_RE


texts = [## try some
            '1-1 [aet]',
            '1-1 [after extra time]',
            '1-1 [after extra-time]',
            '1-1 [After Extra-Time]',
            '1-1 [a.e.t.]',
            '1-1 [ aet ]',
            ####
            '1-1 [aet; 4-3 pen]',
            '1-1 [aet, 4-3p]',
            '1-1 [aet; wins 5-1 on pens]',
            '1-1 [wins 5-1 on pens]',
            '1-1 [wins 5-1 on penalties]',
            ####
            '1-1 [Ajax wins 5-1 on penalties]',
            '1-1 [Ajax wins on away goals]',  ### allow without agg 4-4,  - why? why not?
            ####
            '1-1 [agg 4-4, Ajax wins on away goals]',
            '1-1 [agg 4-3]',
            '1-1 [agg 1-2]',
            '1-1 [wins on away goals]', ## not valid - requires team
            '1-1 [wins on aggregate]',
            '1-1 [wins 5-3 on aggregate]',
            '1-1 [win 5-3 on aggregate]',
            '1-1 [aet; ITA wins 4-3 on pens]',
            '1-1 [ITA wins 4-3 on pens]',

            ### add more
            ##   - allow WITHOUT win e.g. 2-4 on penalties ??
            ##          use    2-4 pen          ??
            ##          or     agg 2-2; 2-4 pen ??
            '1-1 [2-2 on aggregate; wins 2-4 on penalties]',  ## todo - add to regex
            ##  add won too!!!
            '1-1 [Switzerland won 5-4 on penalties]',

            ## check from internationsls
            '1-1 [Iraq wins on penalties]',
         ]


texts.each do |text|
  puts "==> #{text}"
  m=SCORE_NOTE_RE.match( text )

  if m
    puts "  #{m.pretty_inspect}"
  else
    puts "!! note NOT matching"
  end
end




