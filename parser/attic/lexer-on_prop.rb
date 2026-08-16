
PROP_LINEUP_RE = Regexp.union(
   SPACES_RE,
   MINUTE_RE,   ## e.g.  44 or 44' or 45+1 or 45+1' etc.

   INLINE_CAPTAIN,  ## e.g. [c]
   INLINE_YELLOW,   ## e.g. [Y] or [Y 44] or [Y 44'] or [Y 45+1']
   INLINE_YELLOW_RED,  ## e.g. [Y/R] or [Y/R 78] or [YR]
   INLINE_RED,         ## e.g. [R] or [R 42] or [R 42']

   FORMATION_RE,     ## e.g. (4-3-3), (4-1-4-1) etc.

   PROP_KEY_INLINE_RE,
   PROP_NAME_RE,
   /  (?<sym>  [;,()\[\]-]) /x
   ## todo/fix - add ANY_RE here too!!!
)

def _on_prop_lineup( m, ctx: )      ## note - m is MatchData object

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


end