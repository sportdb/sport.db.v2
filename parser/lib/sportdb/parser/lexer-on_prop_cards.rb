module SportDb
class Lexer


def _on_prop_cards( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]
              [:PROP_NAME, m[:name]]
         elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '-' then [:'-']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
             puts "!!! TOKENIZE ERROR (PROP_CARDS_RE) - no match found"
             nil
         end
end

end ## class Lexer
end ## module SportDb
