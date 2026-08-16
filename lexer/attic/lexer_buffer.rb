
class Tokens


def include?( *types )
      pos = @pos
      ## puts "  starting include? #{types.inspect} @ #{pos}"
      while pos < @tokens.size do
          return true   if types.include?( @tokens[pos].type )
          pos +=1
      end
      false
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