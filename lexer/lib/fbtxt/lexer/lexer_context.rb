module Fbtxt
class Lexer


###
## use nested class for context - why? why not?
##   note: first arg passed in MUST be ref to lexer (instance)
class Context
   ## passed along to on_round_def etc. handlers in tokenize_line
   ##   note - for now only offset (in line begin/end) gets updated !!!
     attr_writer :offset
     attr_reader :lineno

     def initialize( lexer,
                     line:,
                     lineno:,
                     errors: )
        @lexer   = lexer
        @line    = line
        @lineno  = lineno
        @errors  = errors

        @offset = [0,0]   ## or use [] aka [nil,nil] for not defined??? why? why not?
        ## @offset = offset    ## MatchData offset e.g. [m.begin(0),m.end(0)]
     end



     def warn_on_else( match, mode: 'TOP' )
         if match[:any]
           _add_warn( "unexpected char >#{match[:any]}< (#{mode})" )
         else
         ##  internal error - shouldn't really happen
           _add_warn( "internal error - unknown match (#{mode}): #{match.inspect}")
         end
     end


     def _add_warn( msg )
        ## note - warns gets logged as error for now too
        ##          maybe add @warns later - why? why not?
        ##
        ##  note - add +1 to offset (start at one - not zero-based)
        ##           will match with (external) text editors
        msg =  "parse error (tokenize) - " +
                          msg +
                " in line @#{@lineno}:#{@offset[0]+1},#{@offset[1]+1} >#{@line}<  "

        @errors << msg
        @lexer.log( "!! WARN - #{msg}" )

        @lexer._warn( msg )
     end

=begin
     ##  use report/log/??_parses_error
     def _add_error( msg )
         msg = "parse error (tokenize) -" +
                          msg +
                " in line #{@lineno}@#{@offset[0]},#{@offse[1]} >#{@line}<  "

        @errors << msg
     end
=end

end  # class Context


end ## class Lexer
end ## module Fbtxt
