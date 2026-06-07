module SportDb
class Lexer



PROP_LINEUP_RE = Regexp.union(
   SPACES_RE,
   MINUTE_RE,   ## e.g.  44 or 44' or 45+1 or 45+1' etc.

   INLINE_CAPTAIN,  ## e.g. [c]
   INLINE_YELLOW,   ## e.g. [Y] or [Y 44] or [Y 44'] or [Y 45+1']
   INLINE_YELLOW_RED,  ## e.g. [Y/R] or [Y/R 78]
   INLINE_RED,         ## e.g. [R] or [R 42] or [R 42']

   PROP_KEY_INLINE_RE,
   PROP_NAME_RE,
   /  (?<sym>  [;,()\[\]-]) /x
   ## todo/fix - add ANY_RE here too!!!
)


def _on_prop_lineup( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]
              ##  supported for now coach/trainer (add manager?)
              if ['coach',
                  'trainer'].include?( key.downcase )
                ## use PROP_COACH or COACH_KEY or such - why? why not?
                Token.new(:COACH, m[:key],
                             lineno: ctx.lineno, offset: m.offset(:key))
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:inline_captain]
              Token.new(:INLINE_CAPTAIN, m[:inline_captain],
                            lineno: ctx.lineno, offset: m.offset(:inline_captain))
         elsif m[:inline_yellow]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              Token.new(:INLINE_YELLOW, m[:inline_yellow],
                               lineno: ctx.lineno, offset: m.offset(:inline_yellow),
                                value: card)
         elsif m[:inline_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              Token.new(:INLINE_RED, m[:inline_red],
                              lineno: ctx.lineno, offset: m.offset(:inline_red),
                              value: card)
         elsif m[:inline_yellow_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              Token.new(:INLINE_YELLOW_RED, m[:inline_yellow_red],
                               lineno: ctx.lineno, offset: m.offset(:inline_yellow_red),
                               value: card)
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
             ctx.warn_on_else( m, mode: 'PROP_LINEUP' )
             nil
         end
end


end ## class Lexer
end ## module SportDb
