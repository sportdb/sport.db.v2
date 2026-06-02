module SportDb
class Lexer



### note - add comma (,) as optional separator
ROUND_DEF_RE = Regexp.union(  SPACES_RE,
                              DURATION_RE,  # note - duration MUST match before date
                              DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                              / (?<sym> [:|,] ) /x,
                              ANY_RE
                           )


def _on_round_def( m, ctx: )      ## note - m is MatchData object


           if m[:spaces] || m[:space]
               nil    ## skip spaces
           elsif m[:date]
            [:DATE, [m[:date], _build_date( m )]]
          elsif m[:duration]
            [:DURATION, [m[:duration], _build_duration( m )]]
          elsif m[:sym]
              [m[:sym].to_sym]   ## e.g. [:'|'],[:':'],[:',']
          else
              if m[:any]
                ctx.warn_skip_any( m[:any], mode: 'ROUND_DEF' )
              else
                ctx.warn_unknown_match( m, mode: 'ROUND_DEF' )
              end
              nil
          end
end

end ## class Lexer
end ## module SportDb
