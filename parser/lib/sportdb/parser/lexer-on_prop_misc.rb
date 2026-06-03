module SportDb
class Lexer



## note - no inline keys possible
##         todo/fix - use custom (limited) prop basics too
PROP_CARDS_RE =  Regexp.union(
   SPACES_RE,
   MINUTE_RE,
   PROP_NAME_RE,
   /  (?<sym>  [;,-]) /x
   ## todo/fix - add ANY_RE here too!!!
)


def _on_prop_cards( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]
              Token.new(:PROP_NAME, m[:name],
                               lineno: ctx.lineno, offset: m.offset(:prop_name))
         elsif m[:minute]
              Token.new(:MINUTE, m[:minute],
                           lineno: ctx.lineno, offset: m.offset(:minute),
                           value: _build_minute( m ))
         elsif m[:sym]
              Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
         else
             ctx.warn_unknown_match( m, mode: 'PROP_CARDS' )
             nil
         end
end



PROP_ATTENDANCE_RE  = Regexp.union(
   SPACES_RE,
   ENCLOSED_NAME_RE,       # e.g. (sold out) etc.  why? why not?
   PROP_NUM_RE,                 # e.g. 28 000 or 28_000  (NOT 28,000 is not valid!!!)
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_attendance( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:enclosed_name]
              ## reserverd for use for sold out or such (in the future) - why? why not?
             Token.new(:ENCLOSED_NAME, m[:name],
                             lineno: ctx.lineno, offset: m.offset(:name))
         elsif m[:num]
             Token.new(:PROP_NUM, m[:num],
                             lineno: ctx.lineno, offset: m.offset(:num),
                             value: { value: m[:value].to_i(10) })
         else
            ctx.warn_unknown_match( m, mode: 'PROP_ATTENDANCE' )
            nil
         end
end



PROP_REFEREE_RE = Regexp.union(
   SPACES_RE,
   ENCLOSED_NAME_RE,       # e.g. (sold out) etc.  why? why not?
   PROP_NUM_RE,                 # e.g. 28 000 or 28_000  (NOT 28,000 is not valid!!!)
   PROP_KEY_INLINE_RE,
   PROP_NAME_RE,
   /  (?<sym>  [;,]) /x
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_referee( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]
              ##  supported for now coach/trainer (add manager?)
              if ['att', 'attn', 'attendance' ].include?( key.downcase )
                ## use ATTENDANCE_PROP or ATTENDANCE_KEY or such - why? why not?
                Token.new(:ATTENDANCE, m[:key],
                                 lineno: ctx.lineno, offset: m.offset(:key))
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:prop_name]    ## note - change prop_name to player or to (plain) name?
              Token.new(:PROP_NAME, m[:name],
                               lineno: ctx.lineno, offset: m.offset(:prop_name))
         elsif m[:num]
             Token.new(:PROP_NUM, m[:num],
                             lineno: ctx.lineno, offset: m.offset(:num),
                             value: { value: m[:value].to_i(10) })
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             Token.new(:ENCLOSED_NAME, m[:name],
                             lineno: ctx.lineno, offset: m.offset(:name))
         elsif m[:sym]
              Token.literal( m[:sym], lineno: ctx.lineno, offset: m.offset(:sym))
         else
            ctx.warn_unknown_match( m, mode: 'PROP_REFEREE' )
            nil
         end
end

end ## class Lexer
end ## module SportDb
