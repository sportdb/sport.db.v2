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
              Token.new(:DATE, m[:date],
                           lineno: ctx.lineno, offset: m.offset(:date),
                           value: _build_date(m))
           elsif m[:duration]
              Token.new(:DURATION, m[:duration],
                            lineno: ctx.lineno, offset: m.offset(:duration),
                            value: _build_duration( m ))
           elsif m[:sym]
              Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
           else
              ctx.warn_on_else( m, mode: 'ROUND_DEF' )
              nil
           end
end

end ## class Lexer
end ## module SportDb
