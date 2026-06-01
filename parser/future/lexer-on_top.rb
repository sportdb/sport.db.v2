

## add more  score format in the future!!!

       elsif m[:score_team]
            [:SCORE_TEAM, [m[:score_team], _build_score_team(m)]]
        elsif m[:score_team_pen]
            [:SCORE_TEAM_PEN, [m[:score_team_pen], _build_score_team_pen(m)]]
        elsif m[:score_team_num]
            [:SCORE_TEAM_NUM, [m[:score_team_num], _build_score_team_num(m)]]

## add minute  to top - why? why not?
##       what is the use case? any samples?

     elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
