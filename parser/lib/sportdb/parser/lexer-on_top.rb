module SportDb
class Lexer


def _on_top( m, ctx: )      ## note - m is MatchData object

        ##  note - top-level (for now always) assumes TEAM for TEXT match!!
        ##           fix/fix/fix change TEXT_RE/:text to  TEAM_RE/:team !!!

        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]         then Token.new(:TEAM,  m[:text],
                                                      lineno: ctx.lineno, offset: m.offset(:text))
        elsif m[:team_home]    then Token.new(:TEAM_HOME,  m[:team_home],
                                                      lineno: ctx.lineno, offset: m.offset(:team_home))
        elsif m[:team_away]    then Token.new(:TEAM_AWAY,  m[:team_away],
                                                      lineno: ctx.lineno, offset: m.offset(:team_away))
        elsif m[:team_neutral] then Token.new(:TEAM_NEUTRAL, m[:team_neutral],
                                                      lineno: ctx.lineno, offset: m.offset(:team_neutral))

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
        elsif m[:inline_wo]   then Token.new(:INLINE_WO, m[:inline_wo],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_wo))
        elsif m[:inline_np]   then Token.new(:INLINE_NP, m[:inline_np],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_np))
        elsif m[:inline_bye]  then Token.new(:INLINE_BYE, m[:inline_bye],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_bye))
        elsif m[:inline_abd]  then Token.new(:INLINE_ABD, m[:inline_abd],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_abd))
        elsif m[:inline_void] then Token.new(:INLINE_VOID, m[:inline_void],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_void))
        elsif m[:inline_susp] then Token.new(:INLINE_SUSP, m[:inline_susp],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_susp))
        elsif m[:inline_ppd]  then Token.new(:INLINE_PPD, m[:inline_ppd],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_ppd))
        elsif m[:inline_awd]  then Token.new(:INLINE_AWD, m[:inline_awd],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_awd))
        elsif m[:inline_canc] then Token.new(:INLINE_CANC, m[:inline_canc],
                                                  lineno: ctx.lineno, offset: m.offset(:inline_canc))
        elsif m[:status]      then Token.new(:STATUS, m[:status],
                                                  lineno: ctx.lineno, offset: m.offset(:status),
                                                  value: _build_status( m ))
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             Token.new(:NOTE, m[:note],
                               lineno: ctx.lineno, offset: m.offset(:note))

        elsif m[:attendance]
             att = {}
             att[:value] = m[:value].gsub( '_', '' ).to_i(10)
             ## note - for token id use INLINE_ATTENDANCE  (ATTENDANCE in use for prop!!!)
            Token.new(:INLINE_ATTENDANCE, m[:attendance],
                                   lineno: ctx.lineno, offset: m.offset(:attendance),
                                          value: att)

        elsif m[:time]         then Token.new(:TIME, m[:time],
                                                lineno: ctx.lineno, offset: m.offset(:time),
                                                value: _build_time(m))
        elsif m[:date]         then Token.new(:DATE, m[:date],
                                                lineno: ctx.lineno, offset: m.offset(:date),
                                                value: _build_date(m))
        elsif m[:date_legs]    then Token.new(:DATE_LEGS, m[:date_legs],
                                                 lineno: ctx.lineno, offset: m.offset(:date_legs),
                                                 value: _build_date_legs(m))

        elsif m[:score_legs]   then Token.new(:SCORE_LEGS, m[:score_legs],
                                                  lineno: ctx.lineno, offset: m.offset(:score_legs),
                                                  value: _build_score_legs( m ))
        elsif m[:score_full]   then Token.new(:SCORE_FULL, m[:score_full],
                                                  lineno: ctx.lineno, offset: m.offset(:score_full),
                                                  value: _build_score_full( m ))
        elsif m[:score_fuller] then Token.new(:SCORE_FULLER, m[:score_fuller],
                                                  lineno: ctx.lineno, offset: m.offset(:score_fuller),
                                                  value: _build_score_fuller( m ))
        elsif m[:score_fuller_more] then Token.new(:SCORE_FULLER_MORE, m[:score_fuller_more],
                                                      lineno: ctx.lineno, offset: m.offset(:score_fuller_more),
                                                      value: _build_score_fuller_more( m ))
        elsif m[:score]      then Token.new(:SCORE,  m[:score],
                                                lineno: ctx.lineno, offset: m.offset(:score),
                                                value: _build_score( m ))
        elsif m[:score_awd]  then Token.new(:SCORE_AWD, m[:score_awd],
                                                lineno: ctx.lineno, offset: m.offset(:score_awd),
                                                value: _build_score_awd( m ))
        elsif m[:score_abd]  then Token.new(:SCORE_ABD, m[:score_abd],
                                                lineno: ctx.lineno, offset: m.offset(:score_abd),
                                                value: _build_score_abd( m ))

        elsif m[:vs]         then Token.new(:VS, m[:vs],
                                              lineno: ctx.lineno, offset: m.offset(:vs))
        elsif m[:sym]
          case m[:sym]  ## return symbols "inline" as is - why? why not?
          when '@'    ##  enter geo mode
            _trace( 'ENTER GEO_RE MODE' )
            @re = GEO_RE
            @geo_count = 0
            Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
          when '('    ## enter goal scorer mode on "free-floating" open paranthesis!!!
             _trace( 'ENTER GOAL_RE MODE' )
             @re = GOAL_RE
              ## note - eat-up ( for now; do NOT pass along as token
              ##       pass along "virutal" INLINE GOALS - why? why not?
              Token.virtual( :INLINE_GOALS, lineno: ctx.lineno )
          else
            Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
          end
        else
           ctx.warn_on_else( m )
           nil
        end
end


end ## class Lexer
end ## module SportDb
