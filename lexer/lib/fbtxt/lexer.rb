require 'cocos'




require_relative 'lexer/version'


## fix-fix-fix -- maybe move upstream into cocos - why? why not?
require_relative 'lexer/debuggable'    ## generic debug/logger helper



##
## add shared/most basic regexes here
## todo - use ANY_RE  to token_commons or such - for shared by many?
module Fbtxt
class Lexer

## general catch-all  (RECOMMENDED (ALWAYS) use as last entry in union)
##   to avoid advance of pos match!!!
ANY_RE = %r{
               (?<any> .)
          }ix

SPACES_RE = %r{
                  (?<spaces> [ ]{2,})
                | (?<space>  [ ])
             }ix


end # class Lexer
end # module Fbtxt


require_relative 'lexer/token-score'
require_relative 'lexer/token-score_full'
require_relative 'lexer/token-score_fuller'
require_relative 'lexer/token-score_legs'
require_relative 'lexer/token-score--helpers'

require_relative 'lexer/token-time'
require_relative 'lexer/token-date--names'
require_relative 'lexer/token-date'
require_relative 'lexer/token-date_duration'
require_relative 'lexer/token-date--helpers'

require_relative 'lexer/token-text'
require_relative 'lexer/token-prop'    ## team prop(erty) mode (note - must be before token)
require_relative 'lexer/token-prop_name'    ## a.k.a token-text_ii
require_relative 'lexer/token-status'
require_relative 'lexer/token-status_inline'
require_relative 'lexer/token-note'
require_relative 'lexer/token-goals'
require_relative 'lexer/token-goals--helpers'
require_relative 'lexer/token-geo'
require_relative 'lexer/token-group'
require_relative 'lexer/token-round'
require_relative 'lexer/token'



require_relative 'lexer/lexer_buffer'   ## incl. Tokens (aka TokenBuffer)
require_relative 'lexer/lexer_token'
require_relative 'lexer/lexer_context'

require_relative 'lexer/lexer-prep_doc'
require_relative 'lexer/lexer-prep_line'

require_relative 'lexer/lexer-logger'   ## e.g. _trace, _warn, _info, etc.
require_relative 'lexer/lexer-on_round_def'
require_relative 'lexer/lexer-on_group_def'
require_relative 'lexer/lexer-on_prop_cards'
require_relative 'lexer/lexer-on_prop_misc'
require_relative 'lexer/lexer-on_prop_lineup'
require_relative 'lexer/lexer-on_prop_penalties'
require_relative 'lexer/lexer-on_goal'
require_relative 'lexer/lexer-on_top'
require_relative 'lexer/lexer-props'

require_relative 'lexer/lexer-tokenize_line'
require_relative 'lexer/lexer-tokenize_norm'     ## that is, normalize (transform) tokens
require_relative 'lexer/lexer'






###
#  make "convenience" lexer api available - why? why not?
#     e.g. - Fbtxt.lex( txt )


module Fbtxt

class LexerResult
   attr_reader :tokens, :errors
   def initialize( tokens, errors=[] )
       @tokens, @errors = tokens, errors
   end

   def ok?()  @errors.size == 0; end
   def nok?() !ok?; end
end  # class LexerResult


def self.lex( txt, flatten: true )      ## returns Fbtxt::LexerResult (ok?/tokens/errors)
  lexer = Lexer.new( txt )
  ## move "wrapping" into result obj inside lexer - why? why not?
  tokens, errors = lexer.tokenize_with_errors( flatten: flatten )
  LexerResult.new( tokens, errors )
end

end #  module Fbtxt


puts Fbtxt::Module::Lexer.banner    # say hello
