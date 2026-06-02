module SportDb
class Lexer




GOAL_RE = Regexp.union(
    SPACES_RE,
    GOAL_NONE_RE,
    GOAL_MINUTE_RE,
    GOAL_MINUTE_NA_RE,
    GOAL_COUNT_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    GOAL_SEP_ALT_RE,   ##  note - add dash (-) with (required) spaces
    /  (?<sym> [;,)])  /x
    ## todo/fix - add ANY_RE !!!!
)

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
             [:GOAL_MINUTE, [m[:goal_minute], _build_goal_minute( m )]]
         elsif m[:goal_minute_na]
              ## note -  (re)use GOAL_MINUTE token; no extra GOAL_MINUTE_NA or such - why? why not?
              ##          make sure to handle 'm' => nil upstream!!!
              ##                     change to  999 or -1 or such - why? why not?
             [:GOAL_MINUTE, [m[:goal_minute_na], _build_goal_minute_na( m )]]
         elsif m[:goal_count]
              [:GOAL_COUNT, [m[:goal_count], _build_goal_count( m )]]
         elsif m[:sym]
            case m[:sym]
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
                [m[:sym].to_sym]
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL' )
            nil
         end
end




GOAL_ALT_RE = Regexp.union(
    SPACES_RE,
    SCORE_RE,        ## e.g.  1-0, 0-1, etc.
    GOAL_MINUTE_RE,
    GOAL_TYPE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    /  (?<sym> [,)])  /x    ## note - no semicolon (;)
    ## todo/fix - add ANY_RE !!!!
)

def _on_goal_alt( m, ctx: )

          if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:goal_minute]
             [:GOAL_MINUTE, [m[:goal_minute], _build_goal_minute( m )]]
         elsif m[:goal_type]
             [:GOAL_TYPE, [m[:goal_type], _build_goal_type( m )]]
         elsif m[:score]
            [:SCORE, [m[:score], _build_score( m )]]
         elsif m[:sym]
            case m[:sym]
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_ALT_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
                [m[:sym].to_sym]
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL_ALT' )
            nil
         end
end



GOAL_COMPAT_RE = Regexp.union(
    SPACES_RE,
    SCORE_RE,        ## e.g.  1-0, 0-1, etc.
    MINUTE_RE,          ## note - matches minute e.g.  92, 7, 7' 7+3, etc.
    GOAL_TYPE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    /  (?<sym> [,)])  /x    ## note - no semicolon (;)
    ## todo/fix - add ANY_RE !!!!
)


def _on_goal_compat( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:minute]
             [:MINUTE, [m[:minute], _build_minute( m )]]
         elsif m[:goal_type]
             [:GOAL_TYPE, [m[:goal_type], _build_goal_type( m )]]
         elsif m[:score]
            [:SCORE, [m[:score], _build_score( m )]]
         elsif m[:sym]
            case m[:sym]
            when ')'  ## leave goal mode!!
                _trace( "LEAVE GOAL_COMPAT_RE MODE" )
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
                [m[:sym].to_sym]
            end
         else
            ctx.warn_unknown_match( m, mode: 'GOAL_COMPAT' )
            nil
         end
end


end ## class Lexer
end ## module SportDb
