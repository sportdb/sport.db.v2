module SportDb
class Lexer



class Token

  ##   Token.newline( lineno: 1, offset: [1,2] )
  ##     maps to =>
  ##   Token.new( :NEWLINE, "\n", lineno: 1, offset: [1,2])
  ##
  ## use self.nl ?
  def self.newline( lineno:, offset: [])
     new( :NEWLINE, "\n", lineno: lineno, offset: offset )
  end

  ##   Token.literal( ",", lineno: 4, offset: [5,6])
  ##    # maps to =>
  ##   Token.new( ",", ",", lineno: 4, offset: [5,6])
  ##
  ## use self.lit?
  def self.literal( literal, lineno:, offset: [])
     new( literal, literal, lineno: lineno, offset: offset )
  end

  ## or use virt or pseudo - why? why not?
  def self.virtual( type, lineno:, offset: [])
     ## note - offset (start/end) should be same number (zero-width assertions!!)
     ## e.g.    :GOALS_COMPAT, "<|GOALS_COMPAT|>"
     new( type, '', lineno: lineno, offset: offset )
  end


  attr_reader :type,   :text,
              :lineno, :offset

  def initialize( type, text='',
                   lineno:, offset: [],
                   value: nil  )
     @type    = type
     @text    = text       # note - lexeme (string from source)
     @lineno  = lineno     # note - lineno (integer number - not line as string) !!!

     raise TypeError, "type Array required for offset; got #{offset.inspect}"  unless offset.is_a?( Array )
     @offset  = offset  # note - for now char offset [start,end] in line (NOT absolute!!)
                         #     maybe latter add MatchData#byteoffset instead - why? why not?
     @value   = value   # might be (union of) string/array/hash
  end

  def value
       ## note - if value is not set (nil) return text (lexeme)
       ##             no need to duplicate text as value
       @value.nil?  ? @text : @value
  end


##  note: do NOT use as_text/text to avoid confusion with (raw) text (lexeme)
##
##  use
##    as_str                -- value (as String)
##    as_int                -- value (as Integer)
##    as_hash               -- value (as Hash)
##    as_ary                -- value (as Array)

  def as_str
      raise TypeError, "token value #{@value.inspect} is #{@value.class.name} NOT string; sorry"   if @value && !@value.is_a?(String)
       ## note - if value is not set (nil) return text (lexeme)
       ##             no need to duplicate text as value
      @value.nil?  ? @text : @value
  end

  def as_int
     raise TypeError, "token value #{@value.inspect} is #{@value.class.name} NOT integer; sorry"    if !@value.is_a?(Integer)
     @value
  end

  def as_hash
     raise TypeError, "token value #{@value.inspect} is #{@value.class.name} NOT hash; sorry"    if !@value.is_a?(Hash)
     @value
  end

  def as_ary
     raise TypeError, "token value #{@value.inspect} is #{@value.class.name} NOT array; sorry"    if !@value.is_a?(Array)
     @value
  end


  def to_legacy
    ## return old "legacy" array format
      if @value.nil?
         [@type, @text]
      else
         [@type, [@text, @value]]
      end
  end


## pretty print
  def pretty_print( printer )
    ## check for literal e.g. "," etc.
    if @type.is_a?( String ) && @type == @text && @value.nil?
       printer.text( "[#{@type.inspect}" )
    elsif @type.is_a?( Symbol ) && @text == ''  && @value.nil?
      ## assume virtual token  (zero-width)
      ##   use <!...!> style
      printer.text( "[<|#{@type}|>" )
    else
      printer.text( "[#{@type.inspect} #{@text.inspect}" )
      printer.text( ", #{value.inspect}")            if @value
    end


    printer.text( " @#{@lineno}" )
    ## note - for now print only start_offset (offset[0])
    ##           to keep dump/output shorter
    ##   note - start counting columns at one (NOT zero), thus, add +1 !!
    printer.text( ":#{@offset[0]+1}" )         if @offset.is_a?(Array) && @offset.size == 2
    printer.text( "]" )
  end

end # class Token



end  # class Lexer
end  # module SportDb
