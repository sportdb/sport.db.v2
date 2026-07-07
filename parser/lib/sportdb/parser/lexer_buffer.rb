
module Fbtxt

## note - Tokens was placed inside Lexer - keep "top-level" for now inside Fbtxt
##            for easier reuse with (new) lexer variants!!

## transforms
##
##  Netherlands  1-2 (1-1)   England
##   =>  text => team
##       score|vs
##       text => team



## token iter/find better name
##  e.g. TokenBuffer/Scanner or such ??
class Tokens
  def initialize( tokens )
      @tokens = tokens
      @pos    = 0
  end

  def pos()  @pos; end
  def eos?() @pos >= @tokens.size; end




  ## pattern e.g. [:TEXT, [:VS,:SCORE], :TEXT]
  def match?( *pattern )
      ## puts "  starting match? #{pattern.inspect} @ #{@pos}"
      pattern.each_with_index do |types,offset|
          tok = peek(offset)
          return false if tok.nil?   ## no more tokens (cannot match)

          ## if single symbol wrap in array
          types = types.is_a?(Array) ? types : [types]
          return false  unless types.include?( tok.type )
      end
      true
  end



  def cur()           peek(0); end

  def peek(offset=1)
      ## return nil if eos
      if @pos+offset >= @tokens.size
          nil
      else
         @tokens[@pos+offset]
      end
  end

  def next
     # if @pos >= @tokens.size
     #     raise ArgumentError, "end of array - #{@pos} >= #{@tokens.size}"
     # end
     #   throw (standard) end of iteration here why? why not?

      t = @tokens[@pos]
      @pos += 1
      t
  end
end  # class Tokens
end # module Fbtxt