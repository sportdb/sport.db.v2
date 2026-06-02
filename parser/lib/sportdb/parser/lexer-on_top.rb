module SportDb
class Lexer


def _on_top( m, ctx: )      ## note - m is MatchData object

        ##  note - top-level (for now always) assumes TEAM for TEXT match!!
        ##           fix/fix/fix change TEXT_RE/:text to  TEAM_RE/:team !!!

        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]         then [:TEAM,         m[:text]]
        elsif m[:team_home]    then [:TEAM_HOME,    m[:team_home]]
        elsif m[:team_away]    then [:TEAM_AWAY,    m[:team_away]]
        elsif m[:team_neutral] then [:TEAM_NEUTRAL, m[:team_neutral]]

        ## (match) status e.g. cancelled, awarded, etc.
        ##  inline:  w/o - walkover
        ##           n/p - not played
        ##           bye
        ##           abd/abd. - abandoned
        ##           void
        ##           susp/susp. - suspended
        ##           ppd/ppd. or postp/postp. - postponed
        ##           awd/awd. - awarded
        ##           canc/canc. - cancelled/canceled
        elsif m[:inline_wo]   then [:INLINE_WO, m[:inline_wo]]
        elsif m[:inline_np]   then [:INLINE_NP, m[:inline_np]]
        elsif m[:inline_bye]  then [:INLINE_BYE, m[:inline_bye]]
        elsif m[:inline_abd]  then [:INLINE_ABD, m[:inline_abd]]
        elsif m[:inline_void] then [:INLINE_VOID, m[:inline_void]]
        elsif m[:inline_susp] then [:INLINE_SUSP, m[:inline_susp]]
        elsif m[:inline_ppd]  then [:INLINE_PPD, m[:inline_ppd]]
        elsif m[:inline_awd]  then [:INLINE_AWD, m[:inline_awd]]
        elsif m[:inline_canc] then [:INLINE_CANC, m[:inline_canc]]
        elsif m[:status]      then [:STATUS, [m[:status], _build_status( m ) ]]
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             [:NOTE, m[:note]]

        elsif m[:attendance]
             att = {}
             att[:value] = m[:value].gsub( '_', '' ).to_i(10)
             ## note - for token id use INLINE_ATTENDANCE  (ATTENDANCE in use for prop!!!)
            [:INLINE_ATTENDANCE, [m[:attendance], att ]]

        elsif m[:time]         then [:TIME,         [m[:time],      _build_time(m)]]
        elsif m[:date]         then [:DATE,         [m[:date],      _build_date(m)]]
        elsif m[:date_legs]    then [:DATE_LEGS,    [m[:date_legs], _build_date_legs(m)]]

        elsif m[:score_legs]   then [:SCORE_LEGS,   [m[:score_legs], _build_score_legs( m )]]
        elsif m[:score_full]   then [:SCORE_FULL,   [m[:score_full], _build_score_full( m )]]
        elsif m[:score_fuller] then [:SCORE_FULLER, [m[:score_fuller], _build_score_fuller( m )]]
        elsif m[:score_fuller_more] then [:SCORE_FULLER_MORE, [m[:score_fuller_more], _build_score_fuller_more( m )]]
        elsif m[:score]      then [:SCORE,     [m[:score],     _build_score( m )]]
        elsif m[:score_awd]  then [:SCORE_AWD, [m[:score_awd], _build_score_awd( m )]]
        elsif m[:score_abd]  then [:SCORE_ABD, [m[:score_abd], _build_score_abd( m )]]

        elsif m[:vs]         then [:VS, m[:vs]]
        elsif m[:sym]
          case m[:sym]  ## return symbols "inline" as is - why? why not?
          when '@'    ##  enter geo mode
            _trace( 'ENTER GEO_RE MODE' )
            @re = GEO_RE
            @geo_count = 0
            [:'@']
          when '('    ## enter goal scorer mode on "free-floating" open paranthesis!!!
             _trace( 'ENTER GOAL_RE MODE' )
             @re = GOAL_RE
              ## note - eat-up ( for now; do NOT pass along as token
              ##       pass along "virutal" INLINE GOALS - why? why not?
              [:INLINE_GOALS, "<|INLINE_GOALS|>"]
          else
             [m[:sym].to_sym]
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
