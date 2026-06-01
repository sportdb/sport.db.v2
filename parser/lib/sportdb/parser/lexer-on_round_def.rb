module SportDb
class Lexer



ROUND_DEF_BASICS_RE = %r{
      (?<spaces> [ ]{2,})
    | (?<space>  [ ])

    | (?<sym> [:|,] )    ### note - add comma (,) as optional separator
}ix

ROUND_DEF_RE = Regexp.union(  ROUND_DEF_BASICS_RE,
                              DURATION_RE,  # note - duration MUST match before date
                              DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                              ANY_RE,
                           )



def _on_round_def( m, ctx: )      ## note - m is MatchData object


           if m[:spaces] || m[:space]
               nil    ## skip spaces
           elsif m[:date]
            [:DATE, [m[:date], _build_date( m )]]
          elsif m[:duration]
            [:DURATION, [m[:duration], _build_duration( m )]]
          elsif m[:sym]
              sym = m[:sym]
              case sym
              when '|' then  [:'|']
              when ':' then  [:':']
              when ',' then  [:',']
              else
                ctx.warn_ignore_sym( sym, mode: 'ROUND_DEF' )
                nil  ## ignore others (e.g. brackets [])
              end
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
