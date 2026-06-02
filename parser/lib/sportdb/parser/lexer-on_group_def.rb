module SportDb
class Lexer



### note - add comma (,) as optional separator
GROUP_DEF_RE = Regexp.union(  SPACES_RE,
                              TEXT_RE,
                              / (?<sym> [:|,] )  /x,
                              ANY_RE,
                           )


def _on_group_def( m, ctx: )      ## note - m is MatchData object

           if m[:spaces] || m[:space]
               nil    ## skip spaces
           elsif m[:text]
               [:TEAM, m[:text]]
           elsif m[:sym]
               [m[:sym].to_sym]   ## e.g. [:'|'],[:':'],[:',']
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
