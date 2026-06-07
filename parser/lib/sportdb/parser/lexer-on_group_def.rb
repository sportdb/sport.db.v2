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
               Token.new(:TEAM,  m[:text],
                 lineno: ctx.lineno, offset: m.offset(:text))
           elsif m[:sym]
                Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
           else
              ctx.warn_on_else( m, mode: 'GROUP_DEF' )
              nil
           end
end


end ## class Lexer
end ## module SportDb
