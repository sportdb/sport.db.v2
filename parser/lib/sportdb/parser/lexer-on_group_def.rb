module SportDb
class Lexer



GROUP_DEF_BASICS_RE = %r{
      (?<spaces> [ ]{2,})
    | (?<space>  [ ])

    | (?<sym> [:|,] )      ### note - add comma (,) as optional separator
}ix


GROUP_DEF_RE = Regexp.union(  GROUP_DEF_BASICS_RE,
                              TEXT_RE,
                              ANY_RE,
                           )


def _on_group_def( m, ctx: )      ## note - m is MatchData object

           if m[:spaces] || m[:space]
               nil    ## skip spaces
           elsif m[:text]
               [:TEAM, m[:text]]
           elsif m[:sym]
              sym = m[:sym]
              case sym
              when '|' then  [:'|']
              when ':' then  [:':']
              when ',' then  [:',']
              else
                ctx.warn_ignore_sym( sym, mode: 'GROUP_DEF' )
                nil  ## ignore others (e.g. brackets [])
              end
           else
              if m[:any]
                ctx.warn_skip_any( m[:any], mode: 'GROUP_DEF' )
              else
                ctx.warn_unknown_match( m, mode: 'GROUP_DEF' )
              end
              nil
           end
end


end ## class Lexer
end ## module SportDb
