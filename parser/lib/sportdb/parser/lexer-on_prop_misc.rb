module SportDb
class Lexer



## note - no inline keys possible
##         todo/fix - use custom (limited) prop basics too
PROP_CARDS_RE =  Regexp.union(
   MINUTE_RE,
   PROP_NAME_RE,
   PROP_BASICS_RE,
   ## todo/fix - add ANY_RE here too!!!
)


def _on_prop_cards( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]
              [:PROP_NAME, m[:name]]
         elsif m[:minute]
             [:MINUTE, [m[:minute], _build_minute( m )]]
         elsif m[:sym]
            case m[:sym]
            when ',' then [:',']
            when ';' then [:';']
            when '-' then [:'-']
            else
              ctx.warn_ignore_sym( m[:sym], mode: 'PROP_CARDS' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
             ctx.warn_unknown_match( m, mode: 'PROP_CARDS' )
             nil
         end
end



PROP_ATTENDANCE_RE  = Regexp.union(
   ENCLOSED_NAME_RE,       # e.g. (sold out) etc.  why? why not?
   PROP_NUM_RE,                 # e.g. 28 000 or 28_000  (NOT 28,000 is not valid!!!)
   PROP_BASICS_RE,
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_attendance( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:enclosed_name]
              ## reserverd for use for sold out or such (in the future) - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
=begin
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
=end
         else
            ctx.warn_unknown_match( m, mode: 'PROP_ATTENDANCE' )
            nil
         end
end



PROP_REFEREE_RE = Regexp.union(
   ENCLOSED_NAME_RE,       # e.g. (sold out) etc.  why? why not?
   PROP_NUM_RE,                 # e.g. 28 000 or 28_000  (NOT 28,000 is not valid!!!)
   PROP_KEY_INLINE_RE,
   PROP_NAME_RE,
   PROP_BASICS_RE,
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_referee( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]
              ##  supported for now coach/trainer (add manager?)
              if ['att', 'attn', 'attendance' ].include?( key.downcase )
                [:ATTENDANCE, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:sym]
            case m[:sym]
            when ',' then [:',']
            when ';' then [:';']
 #           when '[' then [:'[']
 #           when ']' then [:']']
            else
              ctx.warn_ignore_sym( m[:sym], mode: 'PROP_REFEREE' )
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ctx.warn_unknown_match( m, mode: 'PROP_REFEREE' )
            nil
         end
end

end ## class Lexer
end ## module SportDb
