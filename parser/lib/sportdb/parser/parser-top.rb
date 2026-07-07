

module Fbtxt

class ParserResult
   attr_reader :tree, :errors
   def initialize( tree, errors=[] )
       @tree, @errors = tree, errors
   end

   def ok?()  @errors.size == 0; end
   def nok?() !ok?; end
end  # class ParserResult


class Parser
  include Debuggable     ## auto-adds debug?, _trace, _info, etc.

  def initialize( txt )
    @tree   = []
    @errors = []

    lexer = Lexer.new( txt )
    ##  note - use tokenize_with_errors and add/collect tokenize errors
    @tokens, @errors = lexer.tokenize_with_errors
    ## pp @tokens
  end


  def next_token
    tok = @tokens.shift
   ## _trace( "next_token => #{tok.pretty_inspect}" )

    ##  convert to racc format single char literal tokens e.g. '@' etc.
    ##                  note - literal token MUST be string (NOT symbol)
    ##    note - racc expects array with to items
    ##               -  item[0] is the token id
    ##               -  item[1] is the token value

    ## note - returns nil for end-of-file !!!
    tok = [tok.type, tok]   if tok

    tok
  end


#  on_error do |error_token_id, error_value, value_stack|
#      puts "Parse error on token: #{error_token_id}, value: #{error_value}"
#  end

  def parse_with_errors
     _trace( "start parse:" )
     do_parse

     _trace( "#{@tree.size} parse tree node(s): " +  @tree.pretty_inspect)

     [@tree, @errors]
  end


  def parse  ## convenience shortcut (ignores errors)
     puts "[DEPRECATED] parse; use new (porcelain/public) Fbtxt.parse api!!"
     tree, _ = parse_with_errors
     tree
  end

  attr_reader :errors
  def errors?
     puts "[DEPRECATED] errors?; use new (porcelain/public) Fbtxt.parse api!!"
     @errors.size > 0;
  end


  def on_error(error_token_id, error_value, value_stack)
    ## note - get  error_token (as string) e.g. MINUTE, DATE, etc.
    error_token = Racc_token_to_s_table[error_token_id]

    msg = "parse error on token: #{error_token}"

    ## add error_value  - might be Lexer::Token or value
    if error_value.is_a?( Lexer::Token)
      if error_value.type == :NEWLINE
         ## skip print of "literal" newline
      else
         msg << " >#{error_value.text}<"
      end
      msg << " @#{error_value.lineno}"
    else
      msg << " >#{error_value.inspect}"
    end

    ## add stack - why? why not?
    ## "stack: #{value_stack.inspect}"

    _error( msg )

    @errors << msg
  end


end   # class Parser
end  # module Fbtxt
