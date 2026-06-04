module SportDb
class Lexer


##
##  or use
##    as_str  (as_text ??)  -- value (as String)
##    as_int                -- value (as Integer)
##    as_hash               -- value (as Hash)
##    as_ary                -- value (as Array)


##
##
##  fix-fix-fix
##
##   use props      (to avoid to_h  on nil or such)
##         for hash (key/value pairs)
##     or attribs? items?  or   (check Struct naming?)
##
##
##   do NOT add/use to_h
##   add a  to_h   method !!!
##      raise error if value is NOT a hash
##       use in parser.y   instead of  simply .value !!!
##
##
##  yes, change text to lexeme!!!
##        and use text for value (option)!!!!
##
##   add  to_s  (.text - if text renamed to lexeme) ??
##        to_i  (.num)     ??



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

     raise ArgumentError, "type Array required for offset"  unless offset.is_a?( Array )
     @offset  = offset  # note - for now char offset [start,end] in line (NOT absolute!!)
                         #     maybe latter add MatchData#byteoffset instead - why? why not?
     @value   = value   # might be (union of) string/array/hash
  end

  def value
       ## note - if value is not set (nil) return text (lexeme)
       ##             no need to duplicate text as value
       @value.nil?  ? @text : @value
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
