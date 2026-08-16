module Fbtxt
class Lexer


##
## todo - move CARDS_NONE_LEFT_RE,
##             CARDS_SEP_ALT_RE      here!!



######
## todo - add examples for prop cards here !!:


## note - no inline keys possible
##         todo/fix - use custom (limited) prop basics too
PROP_CARDS_RE =  Regexp.union(
   SPACES_RE,
   CARDS_NONE_LEFT_RE,
   CARDS_NONE_RIGHT_RE,
   MINUTE_RE,
   PROP_NAME_RE,
   CARDS_SEP_ALT_RE,     ##  note - add dash (-) with (required) spaces
   /  (?<sym>  [;,]) /x
   ## todo/fix - add ANY_RE here too!!!
)


def _on_prop_cards( m, ctx: )      ## note - m is MatchData object

         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:cards_none_left]
              Token.new(:CARDS_NONE_LEFT, m[0],
                               lineno: ctx.lineno, offset: m.offset(0))
         elsif m[:cards_none_right]
              Token.new(:CARDS_NONE_RIGHT, m[0],
                               lineno: ctx.lineno, offset: m.offset(0))
         elsif m[:cards_sep_alt]
             Token.new( :CARDS_SEP_ALT, m[0],
                              lineno: ctx.lineno, offset: m.offset(0))

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
             ctx.warn_on_else( m, mode: 'PROP_CARDS' )
             nil
         end
end



end ## class Lexer
end ## module Fbtxt
