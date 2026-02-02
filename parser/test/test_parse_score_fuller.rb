###
#  to run use
#     ruby test/test_parse_score_fuller.rb


require_relative 'helper'

class TestParseScoreFuller < Minitest::Test

TEST = <<-TXT

##################
## try fuller score style  (note - no half-time (ht) score possible/allowed here)

###
##    aet
Rapid v Austria  3-2 (aet)
Rapid v Austria  3-2 (a.e.t.)

Rapid 3-2 Austria (aet)
Rapid 3-2 Austria (a.e.t.)

####
##   aet + pen
Rapid v Austria  3-3 (aet, win 5-2 on pens)
Rapid v Austria  3-3 (aet, 5-2 on pens)
Rapid v Austria  3-3 (aet, 5-2 pen)
Rapid v Austria  3-3 (aet, 5-2p)
Rapid v Austria  3-3 (a.e.t., 5-2 pen.)

Rapid 3-3 Austria (aet, win 5-2 on pens)
Rapid 3-3 Austria (aet, 5-2 on pens)
Rapid 3-3 Austria (aet, 5-2 pen)
Rapid 3-3 Austria (aet, 5-2p)
Rapid 3-3 Austria (a.e.t., 5-2 pen.)


#####
##    ft + pen
Rapid v Austria  3-3 (win 5-2 on pens)
Rapid v Austria  3-3 (5-2 on pens)
Rapid v Austria  3-3 (5-2 pen)
Rapid v Austria  3-3 (5-2 pen.)
Rapid v Austria  3-3 (5-2p)

Rapid 3-3 Austria (win 5-2 on pens)
Rapid 3-3 Austria (5-2 on pens)
Rapid 3-3 Austria (5-2 pen)
Rapid 3-3 Austria (5-2 pen.)
Rapid 3-3 Austria (5-2p)


#########
##    ft + agg 
Rapid v Austria  3-2 (win 4-5 on aggregate)
Rapid v Austria  3-2 (4-5 on aggregate)
Rapid v Austria  3-2 (4-5 on agg)
Rapid v Austria  3-2 (4-5 agg)
Rapid v Austria  3-2 (4-5 agg.)
Rapid v Austria  3-2 (agg 4-5)

Rapid 3-2 Austria (win 4-5 on aggregate)
Rapid 3-2 Austria (4-5 on aggregate)
Rapid 3-2 Austria (4-5 on agg)
Rapid 3-2 Austria (4-5 agg)
Rapid 3-2 Austria (4-5 agg.)
Rapid 3-2 Austria (agg 4-5)


########
##    aet + agg + pen

Rapid v Austria   2-1 (aet, 3-3 on aggregate, win 5-2 on pens)
Rapid v Austria   2-1 (aet, 3-3 agg, 5-2 pen.)

Rapid 2-1 Austria (aet, 3-3 on aggregate, win 5-2 on pens)
Rapid 2-1 Austria (aet, 3-3 agg, 5-2 pen.)


####
##   check with HT & FT
Rapid v Austria  3-2 (HT 1-0, FT 2-1, AET)
Rapid 3-2 Austria (HT 1-0, FT 2-1, AET)


####
##  ft + agg + away

Rapid v Austria   2-1 (3-3 on aggregate, win on away goals)
Rapid v Austria   2-1 (3-3 on aggregate, win 2-1 on away goals)
Rapid v Austria   2-1 (agg 3-3, win on away goals)
Rapid v Austria   2-1 (agg 3-3, on away goals)
Rapid v Austria   2-1 (AGG 3-3, AWAY)
Rapid v Austria   2-1 (AGG 3-3, AWAY 2-1)

Rapid 2-1 Austria (3-3 on aggregate, win on away goals)
Rapid 2-1 Austria (3-3 on aggregate, win 2-1 on away goals)
Rapid 2-1 Austria (agg 3-3, win on away goals)
Rapid 2-1 Austria (agg 3-3, on away goals)
Rapid 2-1 Austria (AGG 3-3, AWAY)
Rapid 2-1 Austria (AGG 3-3, AWAY 2-1)




#####
##  test minimal/compact (fuller) style

A 3-1 B (AET)
A 3-1 B (AET, P 5-1)
A 3-1 B (AET, PEN 5-1)
A 3-1 B (AET, AGG 3-3, P 5-1)
A 3-1 B (AET, AGG 3-3, PEN 5-1)


A 3-1 B (HT 1-0, FT 2-2, AET)

A 3-1 B (HT 1-0, FT 2-2, AET, P 5-1)
A 3-1 B (HT 1-0, FT 2-2, AET, PEN 5-1)

A 3-1 B (HT 1-0, FT 2-2, AET, AGG 3-3, P 5-1)
A 3-1 B (HT 1-0, FT 2-2, AET, AGG 3-3, PEN 5-1)

A 3-1 B (HT 1-0, AGG 3-3, AWAY)
A 3-1 B (HT 1-0, AGG 3-3, AWAY 2-3)

TXT



EXP_TREE = [
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2], aet: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {et:[3, 2], aet: true}),
 
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5, 2], et:[3, 3]}),
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
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[3, 2], agg:[4, 5]}),

   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], agg:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], agg:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], aet: true, agg:[3, 3]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {p:[5,2], et:[2, 1], aet: true, agg:[3, 3]}),

   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ht:[1,0], ft:[2,1], et:[3, 2]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ht:[1,0], ft:[2,1], et:[3, 2], aet: true}),

   # Rapid v Austria   2-1 (3-3 on aggregate, win on away goals)
   # Rapid v Austria   2-1 (3-3 on aggregate, win 2-1 on away goals)
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: [2,1]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: [2,1]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: [2,1]}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: true}),
   MatchLine.new( team1: 'Rapid', team2: 'Austria',  score: {ft:[2, 1], agg:[3, 3], away: [2,1]}),


   # A 3-1 B (AET)
   MatchLine.new( team1: 'A', team2: 'B',  score: {et:[3, 1], aet: true}),
   # A 3-1 B (AET, P 5-1)
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], et:[3, 1], aet: true}),
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], et:[3, 1], aet: true}),
   # A 3-1 B (AET, AGG 3-3, P 5-1)
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], et:[3, 1], aet: true, agg:[3,3]}),
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], et:[3, 1], aet: true, agg:[3,3]}),

   #  A 3-1 B (HT 1-0, FT 2-2, AET)
   MatchLine.new( team1: 'A', team2: 'B',  score: {ht:[1,0], ft:[2,2], et:[3, 1], aet: true}),
   #  A 3-1 B (HT 1-0, FT 2-2, AET, P 5-1)
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], ht:[1,0], ft:[2,2], et:[3, 1], aet: true}),
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], ht:[1,0], ft:[2,2], et:[3, 1], aet: true}),
   # A 3-1 B (HT 1-0, FT 2-2, AET, AGG 3-3, P 5-1)
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], ht:[1,0], ft:[2,2], et:[3, 1], aet: true, agg: [3,3]}),
   MatchLine.new( team1: 'A', team2: 'B',  score: {p:[5,1], ht:[1,0], ft:[2,2], et:[3, 1], aet: true, agg: [3,3]}),
   # A 3-1 B (HT 1-0, AGG 3-3, AWAY)
   MatchLine.new( team1: 'A', team2: 'B',  score: {ht:[1,0], ft:[3,1], agg:[3, 3], away:true}),
   # A 3-1 B (HT 1-0, AGG 3-3, AWAY 2-3)
   MatchLine.new( team1: 'A', team2: 'B',  score: {ht:[1,0], ft:[3,1], agg:[3, 3], away:[2,3]}),
  ]



def test_parse
  tree = parse_matches( TEST )
  assert_equal EXP_TREE, tree
end

end # class TestParseScoreFuller
