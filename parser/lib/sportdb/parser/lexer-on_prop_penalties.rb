module SportDb
class Lexer




PROP_PENALTIES_RE = Regexp.union(
   SCORE_RE,               # e.g. 1-1 etc.
   ENCLOSED_NAME_RE,       # e.g. (save), (post), etc.
   PROP_NAME_RE,
   PROP_BASICS_RE,
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
              score = {}
              ## must always have ft for now e.g. 1-1 or such
              ###  change to (generic) score from ft -
              ##     might be score a.e.t. or such - why? why not?
              score[:score] = [m[:score1].to_i(10),
                               m[:score2].to_i(10)]
              [:SCORE, [m[:score], score]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            else
              ctx.warn_ignore_sym( sym, mode: 'PROP_PENALTIES' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ctx.warn_unknown_match( m, mode: 'PROP_PENALTIES ')
            nil
         end
end


end ## class Lexer
end ## module SportDb
