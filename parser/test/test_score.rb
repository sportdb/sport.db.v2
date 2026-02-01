###
#  to run use
#     ruby test/test_score.rb


require_relative 'helper'

class TestScore < Minitest::Test

  

TESTS = [
      ###
      ['5-1 pen. (2-2, 1-1, 1-0)',        { p:[5,1], et:[2,2], ft:[1,1], ht:[1,0]} ],  
      ###
      ['5-1 pen. 2-2 a.e.t. (1-1, 1-0)',  { p:[5,1], et:[2,2], ft:[1,1], ht:[1,0]}],
      ['5-1 pen 2-2 aet (1-1, 1-0)',      { p:[5,1], et:[2,2], ft:[1,1], ht:[1,0]}],
      ['5-1 pen 2-2 aet (1-1,)',          { p:[5,1], et:[2,2], ft:[1,1]}],
      ###
      ['5-1 pen. (1-1)', { p:[5,1], ft:[1,1]}],
      ['5-1 pen. (1-1,)',{ p:[5,1], ft:[1,1]}],
      ['5-1p (1-1)',     { p:[5,1], ft:[1,1]}],
      ['5-1p (1-1,)',    { p:[5,1], ft:[1,1]}],
      ###
      ['2-2 a.e.t.',{ et:[2,2]}],
      ['2-2 aet',   { et:[2,2]}],
      ['2-2aet',    { et:[2,2]}],
      ['5-1 pen. 2-2 a.e.t.',{ p:[5,1], et:[2,2]}],
      ['5-1 pen 2-2 aet',    { p:[5,1], et:[2,2]}],
      ['5-1p 2-2aet',        { p:[5,1], et:[2,2]}],
      ###
      ['5-1 pen.',{ p:[5,1]}],
      ###
      ['1-1 (1-0)',{ ft:[1,1], ht:[1,0]}],
      
      ##   try pen. in last pos
      ['2-2 a.e.t., 5-1 pen.',{ p:[5,1],et:[2,2]}],
      ['2-2 aet, 5-1p',      { p:[5,1],et:[2,2]}],
      ##  -- with comma optional
      ['2-2 a.e.t. 5-1 pen.' ,{ p:[5,1],et:[2,2]}],
      ['2-2aet 5-1pen',       { p:[5,1],et:[2,2]}],
      ## another pn. in last pos style
      ['2-2 a.e.t. (1-1, 1-0), 5-1 pen',{ p:[5,1],et:[2,2],ft:[1,1],ht:[1,0]}],
      ['2-2 a.e.t. (1-1,), 5-1 pen',    { p:[5,1],et:[2,2],ft:[1,1]}],
      ['2-2 a.e.t. (1-1), 5-1 pen',     { p:[5,1],et:[2,2],ft:[1,1]}],
      ##  -- with comma optional
      ['2-2 a.e.t. (1-1, 1-0) 5-1 pen', { p:[5,1],et:[2,2],ft:[1,1],ht:[1,0]}],
      ['2-2 a.e.t. (1-1) 5-1 pen',      { p:[5,1],et:[2,2],ft:[1,1]}],
      ##  try ft with pen. in last pos
      ['2-2, 5-1 pen.', { p:[5,1], ft:[2,2]}],
      ['2-2, 5-1p',    { p:[5,1], ft:[2,2]}],
      ['2-2, 12-11pen', { p:[12,11], ft:[2,2]}],
  ]


def test_score  
  TESTS.each do |text, exp_score|
  
     score=SportDb::Lexer._parse_score_full( text )

     if score        
      ## pp score
       puts "OK #{text}  -  #{score.pretty_inspect}"
       assert_equal exp_score, score
    else
       puts "!! score (full) NOT matching - #{text}"
       assert false
    end
  end
end

end # class TestScore
