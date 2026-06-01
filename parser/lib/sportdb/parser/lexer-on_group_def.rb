module SportDb
class Lexer


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
                puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
                nil  ## ignore others (e.g. brackets [])
              end
           elsif m[:any]
              ## todo/check log error
               msg = "parse error (tokenize group_def) - skipping any match>#{m[:any]}< @#{ctx.offsets[0]},#{ctx.offsets[1]} in line >#{ctx.line}<"
               puts "!! WARN - #{msg}"

               ctx.errors << msg
               log( "!! WARN - #{msg}" )

               nil
            else
              ## report error/raise expection
               puts "!!! TOKENIZE ERROR - no match found"
               nil
            end
end


end ## class Lexer
end ## module SportDb
