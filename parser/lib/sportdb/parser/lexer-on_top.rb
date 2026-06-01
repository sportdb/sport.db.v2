module SportDb
class Lexer


def _on_top( m, ctx: )      ## note - m is MatchData object

        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]
          ##  note - top-level (for now always) assumes TEAM for TEXT match!!
          [:TEAM, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
            [:STATUS, [m[:status], _build_status( m ) ]]
        elsif m[:inline_wo]   ## w/o - walkover  (match status)
            [:INLINE_WO, m[:inline_wo]]
        elsif m[:inline_np]   ## n/p - not played (match status)
            [:INLINE_NP, m[:inline_np]]
        elsif m[:inline_bye]  ## bye  (match status)
            [:INLINE_BYE, m[:inline_bye]]
        elsif m[:inline_abd]  ## abd/abd. - abandoned (match status)
            [:INLINE_ABD, m[:inline_abd]]
        elsif m[:inline_void]  ## abd/abd. - abandoned (match status)
            [:INLINE_VOID, m[:inline_void]]
        elsif m[:inline_susp]  ## susp/susp. - suspended (match status)
            [:INLINE_SUSP, m[:inline_susp]]
        elsif m[:inline_ppd]  ## ppd/ppd. or postp/postp. - postponed (match status)
            [:INLINE_PPD, m[:inline_ppd]]
        elsif m[:inline_awd]  ## awd/awd. - awarded (match status)
            [:INLINE_AWD, m[:inline_awd]]
        elsif m[:inline_canc]  ## canc/canc. - cancelled/canceled (match status)
            [:INLINE_CANC, m[:inline_canc]]

        elsif m[:team_home]
            [:TEAM_HOME, m[:team_home]]
        elsif m[:team_away]
            [:TEAM_AWAY, m[:team_away]]
        elsif m[:team_neutral]
            [:TEAM_NEUTRAL, m[:team_neutral]]

        elsif m[:attendance]
             att = {}
             att[:value] = m[:value].gsub( '_', '' ).to_i(10)
             ## note - for token id use INLINE_ATTENDANCE  (ATTENDANCE in use for prop!!!)
            [:INLINE_ATTENDANCE, [m[:attendance], att ]]
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             [:NOTE, m[:note]]
        elsif m[:time]
            [:TIME, [m[:time], _build_time(m)]]
        elsif m[:date]
            [:DATE, [m[:date], _build_date(m)]]
        elsif m[:date_legs]
            [:DATE_LEGS, [m[:date_legs], _build_date_legs(m)]]
        elsif m[:score_team]
            [:SCORE_TEAM, [m[:score_team], _build_score_team(m)]]
        elsif m[:score_team_pen]
            [:SCORE_TEAM_PEN, [m[:score_team_pen], _build_score_team_pen(m)]]
        elsif m[:score_team_num]
            [:SCORE_TEAM_NUM, [m[:score_team_num], _build_score_team_num(m)]]
          elsif m[:score_legs]
              legs = {}

              ### leg1
              score = {}
              score[:ft] = [m[:leg1_ft1].to_i(10),
                            m[:leg1_ft2].to_i(10)]
              legs['leg1'] = score

              ### leg2
              score = {}
              score[:ft] = [m[:leg2_ft1].to_i(10),
                            m[:leg2_ft2].to_i(10)]  if m[:leg2_ft1] && m[:leg2_ft2]
              score[:et] = [m[:leg2_et1].to_i(10),
                            m[:leg2_et2].to_i(10)]  if m[:leg2_et1] && m[:leg2_et2]
              score[:p]  = [m[:leg2_p1].to_i(10),
                            m[:leg2_p2].to_i(10)]  if m[:leg2_p1] && m[:leg2_p2]
              legs['leg2'] = score

              ## check for (opt) aggregate - keep on "top-level"
              legs[:agg] = [m[:agg1].to_i(10),
                            m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              legs[:away] = true  if m[:away]

              ## note - for debugging keep (pass along) "literal" score
              [:SCORE_LEGS, [m[:score_legs], legs]]
        elsif m[:score_full]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]

              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULL, [m[:score_full], score]]
        elsif m[:score_fuller]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add aet flag true/false
              # score[:aet] = true   if m[:aet] || m[:aetgg] || m[:aetsg]

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER, [m[:score_fuller], score]]
        elsif m[:score_fuller_more]
               ##    SCORE + SCORE_FULLER_MORE
               ## note -  after extra-time (aet) or full-time (ft)
               ##           score may be present in SCORE!!!
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add flag in score for et/ft/ht
              score[:score] = 'et'   if m[:aet] || m[:aetgg] || m[:aetsg]
              score[:score] = 'ft'   if m[:ft]
              score[:score] = 'ht'   if m[:ht]

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER_MORE, [m[:score_fuller_more], score]]
        elsif m[:score]
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
         ## note - for debugging keep (pass along) "literal" score
          [:SCORE, [m[:score], score]]
        elsif m[:score_awd]   ## score awarded (awd/awd.)
            score = {}
            ### note - use "generic" score for now
            ##         to match  A 3-0 B [awarded] etc.
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:awarded] = true ???
            ##    or only use match status to avoid duplicate?
            [:SCORE_AWD, [m[:score_awd], score]]
        elsif m[:score_abd]   ## score abandonded (abd/abd.)
            score = {}
            ### note - use "generic" score for now
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:awarded] = true ???
            ##    or only use match status to avoid duplicate?
            [:SCORE_ABD, [m[:score_abd], score]]
      elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
        elsif m[:vs]
           [:VS, m[:vs]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          ## (?<sym>[;,@|\[\]-])

          case sym
          when '@'    ##  enter geo mode
            _trace( 'ENTER GEO_RE MODE' )
            @re = GEO_RE
            @geo_count = 0
            [:'@']
          when ',' then [:',']
          when ';' then [:';']
          when '/' then [:'/']
          when '|' then [:'|']
          when '[' then [:'[']
          when ']' then [:']']
          when '-' then [:'-']
          when '('    ## enter goal scorer mode on "free-floating" open paranthesis!!!
             _trace( 'ENTER GOAL_RE MODE' )
             @re = GOAL_RE
              ## note - eat-up ( for now; do NOT pass along as token
              ##       pass along "virutal" INLINE GOALS - why? why not?
              [:INLINE_GOALS, "<|INLINE_GOALS|>"]
          when ')' then [:')']
          else
            ctx.warn_ignore_sym( sym )
            nil  ## ignore others (e.g. brackets [])
          end
        else
           if m[:any]
             ctx.warn_skip_any( m[:any] )
           else
             ctx.warn_unknown_match( m )
           end
           nil
        end
end


end ## class Lexer
end ## module SportDb
