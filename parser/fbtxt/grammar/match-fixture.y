###
##  note - match_fixture   is always match WITHOUT SCORE
##                         e.g. two TEAMS
##                                with optional inline match status
##                                  - not/played, cancelled, postponed
##
##  for match WITH SCORE see match_result rule

    ## note - does NOT include SCORE; use SCORE terminal "in-place" if needed



         match_sep :  '-' | VS


         match_fixture :  TEAM  match_sep  TEAM
                           {
                               _trace( "RECUDE match_fixture" )
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str }
                           }



### todo/fix - change to match_fixture_canceled
##                     or keep - why? why not?!!!!

match_fixture_not_played : TEAM INLINE_NP TEAM
                            {
                               ## note - auto-add (match) status canceled - why? why not?
                               ##   A n/p B   short (inline) form of =>
                               ##   A v B [canceled]

                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'canceled' }
                             }
                          | TEAM INLINE_CANC TEAM
                             {
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'canceled' }
                            }

 match_fixture_postponed  :  TEAM INLINE_PPD TEAM
                             {
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'postponed' }
                            }
