###
#  to run use
#     ruby test/test_parse_score_fuller.rb


require_relative 'helper'

class TestParseScoreFuller < Minitest::Test

TEST = <<-TXT

##################
## try fuller score style  (note - no half-time (ht) score possible/allowed here)

Rapid v Austria  3-2 (aet)
Rapid v Austria  3-2 (a.e.t.)

Rapid v Austria  3-3 (aet, win 5-2 on pens)
Rapid v Austria  3-3 (aet, 5-2 on pens)
Rapid v Austria  3-3 (aet, 5-2 pen)
Rapid v Austria  3-3 (aet, 5-2p)
Rapid v Austria  3-3 (a.e.t., 5-2 pen.)

Rapid v Austria  3-3 (win 5-2 on pens)
Rapid v Austria  3-3 (5-2 on pens)
Rapid v Austria  3-3 (5-2 pen)
Rapid v Austria  3-3 (5-2 pen.)
Rapid v Austria  3-3 (5-2p)

Rapid v Austria  3-2 (win 4-5 on aggregate)
Rapid v Austria  3-2 (4-5 on aggregate)
Rapid v Austria  3-2 (4-5 on agg)
Rapid v Austria  3-2 (4-5 agg)
Rapid v Austria  3-2 (4-5 agg.)
Rapid v Austria  3-2 (agg 4-5)

Rapid v Austria   2-1 (aet, 3-3 on aggregate, win 5-2 on pens)
Rapid v Austria   2-1 (aet, 3-3 agg, 5-2 pen.)


TXT


MatchLine = RaccMatchParser::MatchLine


EXP_TREE = [
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2], aet: true}),
 
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3], aet: true}),

   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], ft:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], ft:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], ft:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], ft:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], ft:[3, 3]}),

   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),

   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], aet: true, agg:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], aet: true, agg:[3, 3]}),
]


def test_parse
  parser = RaccMatchParser.new( TEST, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end

  assert_equal EXP_TREE, tree
end

end # class TestParseScoreFuller
