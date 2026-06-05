###
##  note - change/rename  _base  to _home_away or such - why? why not?

         ##########################
         ####  shortcuts (H), (A), (N) with base team
         ##         (H) = Home, (A) = Away, (N) = Neutral
         ##     note: use underscore (_) for base team placeholder for now

         match_fixture_base
                   :  TEAM_HOME    TEAM  { result = { team1: '_', team2: val[1].value } }
                   |  TEAM_AWAY    TEAM  { result = { team1: val[1].value, team2: '_' } }
                   |  TEAM_NEUTRAL TEAM  { result = { team1: '_', team2: val[1].value,
                                                       neutral: true } }


         match_result_base
                    :  match_fixture_base SCORE
                        {
                          _trace( "REDUCE  => match_result_base : match_fixture_base SCORE" )
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          result = { score: val[1].value[:score]  ## note - as array e.g. [1,1] !!
                                   }.merge( val[0] )
                        }
                    |  match_fixture_base  SCORE_FULL_OR_FULLER
                        {
                          _trace( "REDUCE  => match_result_base : match_fixture_base SCORE_FULL_OR_FULLER" )
                          result = { score: val[1].value }.merge( val[0] )
                        }
