####
#  to run use:
#    $ ruby sandbox/test_score.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


SCORE_MORE_RE  = SportDb::Lexer::SCORE_MORE_RE


texts = [## try some
      ###
      '5-1 pen. (2-2, 1-1, 1-0)',  
      ###
      '5-1 pen. 2-2 a.e.t. (1-1, 1-0)',
      '5-1 pen 2-2 aet (1-1, 1-0)',
      '5-1 pen 2-2 aet (1-1,)',
      ###
      '5-1 pen. (1-1)',
      '5-1p (1-1)',
      ###
      '2-2 a.e.t.',
      '2-2 aet',
      '2-2aet',
      '5-1 pen. 2-2 a.e.t.',
      '5-1 pen 2-2 aet',
      '5-1p 2-2aet',
      ###
      '5-1 pen.',
      ###
      '5-1 pen.',
      '5-1 pen. (1-1)',
      '5-1 pen. (1-1,)',
      '5-1p (1-1)',
      '5-1p (1-1,)',
      ###
      '1-1 (1-0)',
      ##   try pen. in last pos
      '2-2 a.e.t., 5-1 pen.',
      '2-2 aet, 5-1 p',
      '2-2 a.e.t. 5-1 pen.',
      '2-2aet 5-1pen',
      ## another style
      '2-2 a.e.t. (1-1, 1-0), 5-1 pen',
      '2-2 a.e.t. (1-1,), 5-1 pen',
      '2-2 a.e.t. (1-1), 5-1 pen',
      '2-2 a.e.t. (1-1, 1-0) 5-1 pen',
      '2-2 a.e.t. (1-1) 5-1 pen',
         ]

texts.each do |text|
  puts "==> #{text}"
  m=SCORE_MORE_RE.match( text )

  if m
    score = {}
    score['p']  = [m[:p1].to_i,m[:p2].to_i]   if m[:p1] && m[:p2]
    score['et'] = [m[:et1].to_i,m[:et2].to_i]   if m[:et1] && m[:et2]
    score['ft'] = [m[:ft1].to_i,m[:ft2].to_i]   if m[:ft1] && m[:ft2]
    score['ht'] = [m[:ht1].to_i,m[:ht2].to_i]   if m[:ht1] && m[:ht2]
       
    ## pp m
    pp score
  else
    puts "!! NOT matching"
  end
end



puts "bye"