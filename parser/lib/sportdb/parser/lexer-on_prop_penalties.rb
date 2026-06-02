module SportDb
class Lexer




PROP_PENALTIES_RE = Regexp.union(
   SPACES_RE,
   SCORE_RE,               # e.g. 1-1 etc.
   ENCLOSED_NAME_RE,       # e.g. (save), (post), etc.
   PROP_NAME_RE,
    /  (?<sym>  [;,]) /x    ## add [] too - why? why not?
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_penalties( m, ctx: )      ## note - m is MatchData object
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:score]
              [:SCORE, [m[:score], _build_score( m )]]
         elsif m[:sym]
              [m[:sym].to_sym]   ## e.g. [:','] or [:';']
         else
            ctx.warn_unknown_match( m, mode: 'PROP_PENALTIES ')
            nil
         end
end


end ## class Lexer
end ## module SportDb
