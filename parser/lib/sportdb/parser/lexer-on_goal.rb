module SportDb
class Lexer


def _on_goal_compat( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:minute]
              minute = _build_minute( m )
             [:MINUTE, [m[:minute], minute]]
         elsif m[:goal_type]
              goal_type = _build_goal_type( m )
             [:GOAL_TYPE, [m[:goal_type], goal_type]]
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
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_COMPAT_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              ctx.warn_ignore_sym( sym, mode: 'GOAL_COMPAT' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL_COMPAT' )
            nil
         end
end


def _on_goal_alt( m, ctx: )

          if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:goal_minute]
              minute = _build_goal_minute( m )
             [:GOAL_MINUTE, [m[:goal_minute], minute]]
         elsif m[:goal_type]
              goal_type = _build_goal_type( m )
             [:GOAL_TYPE, [m[:goal_type], goal_type]]
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
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_ALT_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              ctx.warn_ignore_sym( sym, mode: 'GOAL_ALT' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL_ALT' )
            nil
         end
end


def _on_goal( m, ctx: )

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:goals_none]    ## note - eats-up semicolon!! e.g. -; or - ;
             [:GOALS_NONE, "<|GOALS_NONE|>"]
         elsif m[:goal_sep_alt]
             [:GOAL_SEP_ALT, "<|GOAL_SEP_ALT|>" ]   ## e.g. dash (-) WITH leading & trailing space required
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:goal_minute]
              minute = _build_goal_minute( m )
             [:GOAL_MINUTE, [m[:goal_minute], minute]]
         elsif m[:goal_minute_na]
              minute = _build_goal_minute_na( m )
              ## note -  (re)use GOAL_MINUTE token; no extra GOAL_MINUTE_NA or such - why? why not?
              ##          make sure to handle 'm' => nil upstream!!!
              ##                     change to  999 or -1 or such - why? why not?
             [:GOAL_MINUTE, [m[:goal_minute_na], minute]]
         elsif m[:goal_count]
              count = _build_goal_count( m )
              [:GOAL_COUNT, [m[:goal_count], count]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              ctx.warn_ignore_sym( sym, mode: 'GOAL' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL' )
            nil
         end
end



end ## class Lexer
end ## module SportDb
