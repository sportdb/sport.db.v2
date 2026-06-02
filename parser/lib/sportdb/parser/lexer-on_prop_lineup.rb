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
                [:COACH, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:inline_captain]
              [:INLINE_CAPTAIN, m[:inline_captain]]
         elsif m[:inline_yellow]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_YELLOW, [m[:inline_yellow], card]]
         elsif m[:inline_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_RED, [m[:inline_red], card]]
         elsif m[:inline_yellow_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_YELLOW_RED, [m[:inline_yellow_red], card]]
         elsif m[:prop_name]
              [:PROP_NAME, m[:name]]
         elsif m[:minute]
             [:MINUTE, [m[:minute], _build_minute( m )]]
         elsif m[:sym]
              [m[:sym].to_sym]   ## e.g. [:';'],[:','],etc.
         else
             ctx.warn_unknown_match( m, mode: 'PROP_LINEUP' )
             nil
         end
end


end ## class Lexer
end ## module SportDb
