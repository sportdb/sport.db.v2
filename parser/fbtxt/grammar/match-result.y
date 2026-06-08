

    SCORE_FULL_OR_FULLER
                : SCORE_FULL      ## full format    1-1 (0-1)
                                  ##             or 2-1 a.e.t. etc.
                | SCORE_FULLER    ## note - SCORE_FULLER NOT supported inline!!
                                  ##       only after  Team1 v Team2 !!
                                  ##  for inline use MUST BE (split into two e.g.)
                                  ##      TEAM SCORE TEAM SCORE_FULLER_MORE !!


        match_result :  TEAM  SCORE  TEAM
                         {
                           _trace( "REDUCE => match_result : TEAM SCORE TEAM" )

                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          ##      - as array e.g. [1,1] !!
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary
                                    }
                        }
                     | TEAM SCORE_AWD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary,
                                      status_inline: 'awarded'
                                    }
                          }
                     | TEAM SCORE_ABD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary,
                                      status_inline: 'abandoned'
                                    }
                          }
                     | TEAM SCORE TEAM SCORE_FULLER_MORE
                          {
                            _trace( "REDUCE => match_result : TEAM SCORE TEAM SCORE_FULLER_MORE" )
                            score =  if val[3].as_hash[:score] &&
                                        val[3].as_hash[:score]=='et'   ## check aet flag present?
                                         val[3].as_hash.delete( :score )  ## note - remove/delete  flag
                                           { et: val[1].as_ary }
                                     elsif val[3].as_hash[:score] &&
                                           val[3].as_hash[:score]=='ht' ## check ht flag present?
                                         val[3].as_hash.delete( :score ) ## note - remove/delete flag
                                           { ht: val[1].as_ary }
                                     elsif val[3].as_hash[:score] &&
                                           val[3].as_hash[:score]=='ft'  ## check ft flag present?
                                         val[3].as_hash.delete( :score )  ## note - remove/delete flag
                                           { ft: val[1].as_ary }
                                     else   ## assume full-time (ft)
                                            { ft: val[1].as_ary }
                                     end

                           result = {  team1: val[0].as_str,
                                      team2: val[2].as_str,
                                      score: score.merge( val[3].as_hash )
                                    }
                          }
                     | TEAM SCORE_FULL TEAM
                         {
                           result = { team1: val[0].as_str,
                                      team2: val[2].as_str,
                                      score: val[1].as_hash
                                    }
                         }


                     ############
                     #  match fixture-style WITH SCORE!!!
                     #    e.g.  Austria v Rapid 3-2  or
                     #          Austria - Rapid 3-2

                     |  match_fixture  SCORE   ## note - keep "plain/generic" score separate rule
                        {
                          _trace( "REDUCE  => match_result : match_fixture SCORE" )
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          ##      - as array e.g. [1,1] !!
                          result = { score: val[1].as_ary }.merge( val[0] )
                        }
                     |  match_fixture  SCORE_FULL_OR_FULLER
                        {
                          _trace( "REDUCE  => match_result : match_fixture SCORE_FULL_OR_FULLER" )
                          result = { score: val[1].as_hash }.merge( val[0] )
                        }

                    ####################
                    ### with inline match status e.g.
                    ##     awarded (awd.),
                    ##     abandoned (abd.)
                    ##     void       -- aka annulled
                    ##     suspendend (susp.)
                    | TEAM INLINE_AWD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'awarded'
                                    }
                          }
                     | TEAM INLINE_ABD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'abandoned'
                                    }
                          }
                     | TEAM INLINE_VOID TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'annulled'
                                    }
                          }
                     | TEAM INLINE_SUSP TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'suspended'
                                    }
                          }
