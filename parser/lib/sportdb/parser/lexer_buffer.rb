
module SportDb

## note - Tokens was placed inside Lexer - keep "top-level" for now inside SportDb
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
      @pos = 0
  end

  def pos()  @pos; end
  def eos?() @pos >= @tokens.size; end


  def include?( *types )
      pos = @pos
      ## puts "  starting include? #{types.inspect} @ #{pos}"
      while pos < @tokens.size do
          return true   if types.include?( @tokens[pos][0] )
          pos +=1
      end
      false
  end

  ## pattern e.g. [:TEXT, [:VS,:SCORE], :TEXT]
  def match?( *pattern )
      ## puts "  starting match? #{pattern.inspect} @ #{@pos}"
      pattern.each_with_index do |types,offset|
          ## if single symbol wrap in array
          types = types.is_a?(Array) ? types : [types]
          return false  unless types.include?( peek(offset) )
      end
      true
  end


  ## return token type  (e.g. :TEXT, :NUM, etc.)
  def cur()           peek(0); end
  ## return content (assumed to be text)
  def text(offset=0)
      ## raise error - why? why not?
      ##   return nil?
      if peek( offset ) != :text
          raise ArgumentError, "text(#{offset}) - token not a text type"
      end
      @tokens[@pos+offset][1]
  end


  def peek(offset=1)
      ## return nil if eos
      if @pos+offset >= @tokens.size
          nil
      else
         @tokens[@pos+offset][0]
      end
  end

  ## note - returns complete token
  def next
     # if @pos >= @tokens.size
     #     raise ArgumentError, "end of array - #{@pos} >= #{@tokens.size}"
     # end
     #   throw (standard) end of iteration here why? why not?

      t = @tokens[@pos]
      @pos += 1
      t
  end

  def collect( &blk )
      tokens = []
      loop do
        break if eos?
        tokens <<  if block_given?
                      blk.call( self.next )
                   else
                      self.next
                   end
      end
      tokens
  end
end  # class Tokens
end # module SportDb