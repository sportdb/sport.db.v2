
####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser



  def initialize( txt,  debug: false )
    @tree   = []
    @errors = []

    lexer = SportDb::Lexer.new( txt, debug: debug )
    ##  note - use tokenize_with_errors and add/collect tokenize errors
    @tokens, @errors = lexer.tokenize_with_errors
    ## pp @tokens

    @debug = debug
  end


  ## def debug( value ) @debug = value; end   ### fix: use setter-style e.g. debug=(value) !!!
  def debug?()  @debug == true; end


  def _trace( *args )
    if debug?
      print "[DEBUG] Parser -- "
      args.each { |arg| puts args }
    end
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
     [@tree, @errors]
  end

  def parse  ## convenience shortcut (ignores errors)
    tree, _ = parse_with_errors
    tree
  end


  attr_reader :errors
  def errors?()   @errors.size > 0; end


  def on_error(error_token_id, error_value, value_stack)
    ## auto-add error_token (as string)
    error_token = Racc_token_to_s_table[error_token_id]
    args = [error_token, error_token_id, error_value, value_stack]

    puts
    puts "!! on parse error:"
    puts "args=#{args.pretty_inspect}"

    @errors << "parse error on token: #{error_token} >#{error_value.pretty_inspect}<, stack: #{value_stack.pretty_inspect}"
  end


end   # class RaccMatchParser