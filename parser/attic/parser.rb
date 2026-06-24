

=begin
module SportDb
   def self.parser() @@parser ||= Parser.new; end
   def self.parse( ... )
   end
   def self.tokenize( ... )
   end
end  # module SportDb
=end



module SportDb
class Parser
####################
#  "default" lexer & parser  (wraps RaccMatchParser)

  def tokenize_with_errors( lines, debug: false )
     lexer = Lexer.new( lines )
     tokens, errors = lexer.tokenize_with_errors
     [tokens, errors]
  end

  ### convience helper - ignore errors by default
  def tokenize( lines, debug: false )
    tokens, _ = tokenize_with_errors( lines, debug: debug )
    tokens
  end


  def parse_with_errors( lines, debug: false )
    ## todo/check - if lines needs to chack for array of lines and such
    ##                        or handled by tokenizer???
    parser = RaccMatchParser.new( lines )
    tree, errors = parser.parse_with_errors
    [tree, errors]
  end

  ### convience helper - ignore errors by default
  def parse( lines, debug: false )
    tree, _ = parse_with_errors( lines, debug: debug )
    tree
  end
end  # class Parser
end  # module SportDb
