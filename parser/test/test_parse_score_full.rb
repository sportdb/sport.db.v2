###
#  to run use
#     ruby test/test_parse_score_full.rb


require_relative 'helper'

class TestParseScoreFull < Minitest::Test

TEST = <<-TXT

##################
## try full score style 

###
Rapid v Austria  5-1 pen. (2-2, 1-1, 1-0)

###
Rapid v Austria  5-1 pen. 2-2 a.e.t. (1-1, 1-0)
Rapid v Austria  5-1 pen 2-2 aet (1-1, 1-0)
Rapid v Austria  5-1 pen 2-2 aet (1-1,)

TXT


EXP_TREE = [
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,1],et:[2, 2],ft:[1,1],ht:[1,0]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,1],et:[2, 2],ft:[1,1],ht:[1,0]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,1],et:[2, 2],ft:[1,1],ht:[1,0]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,1],et:[2, 2],ft:[1,1]}),   
]


def test_parse
  tree = parse_matches( TEST )
  assert_equal EXP_TREE, tree
end

end # class TestParseScoreFull
