# NanoBASIC/tokenizer.rb

######
## difference to "upstream" (original) NanoBASIC lexer
##    add optional ' for REM e.g.
##      REM  check negative numbers or
##      '    check negative numbers
##
##    remove -? from NUMBER (handled by MINUS)
##    whitespace - handles multiple spaces/tabs (BUT no newline)




class Token
  attr_reader :type, :value
  def initialize( type, text,
                  lineno: nil, offset: [], value: nil)
    @type   = type
    @text   = text
    @lineno = lineno
    @offset = offset   ## col_start,col_end e.g. [25,26]
    @value  = value    # string or number
  end

  def pretty_print(q)
    q.group( 4, '[:', ']') do
        if @type.is_a?( String )  ## assume "literal" (dont duplicate text)
          q.pp( @type )
        else
          q.text( @type )
          ## q.text( " " )
          ## q.pp( @text )
        end
        q.text( " @#{@lineno}" )
        q.text( ",#{@offset.join(':')}" )   unless @offset.empty?
        if @value
           q.text( " " )
           q.pp( @value )
        end
  end
end
end   ## class Token





class NanoBasicLexer

TOKEN_RE = Regexp.union(
    %r{   (?<COMMENT>      (?: rem \b |') .*  )}ix,
    %r{   (?<WHITESPACE>   [ \t\n]+   )}x,

    %r{   (?<KEYWORD>   (?:  print
                           | if
                           | then
                           | let
                           | goto
                           | gosub
                           | return) \b ) }ix,   ## check add word boundray - why? why not
                                            ##  e.g.  will print match println ???

    ## operators/punctuation
    %r{   (?<SYM> (?:  ,   ## COMMA
                    |  =   ## EQUAL
                    |  <>  ## NOT_EQUAL      -- note - drop ><
                    |  <=  ## LESS_EQUAL
                    |  <   ## LESS
                    |  >=  ## GREATER_EQUAL
                    |  >   ## GREATER
                    | \+   ## PLUS
                    |  -   ## MINUS
                    | \*   ## MULTIPLY
                    |  /   ## DIVIDE
                    | \(   ## OPEN_PAREN
                    | \)   ## CLOSE_PAREN
                   ))}x,

    %r{  (?<VARIABLE>   [A-Za-z_]+ )}x,
    %r{  (?<NUMBER>    [0-9]+ )}x,      ## note -   -? handled/matched by MINUS
    %r{  (?<STRING>   "[^"]*") }x,

    %r{   (?<ANY> . ) }x   ## last - catch all/fall back for any character
    )


## note - add \G anchor
##
## tip: StringScanner is a built-in Ruby library specifically designed for this.
##  It maintains an internal pos pointer and automatically
##  uses the \G behavior under the hood to ensure your parsing is 100% contiguous
##  and leaves no gaps.
TOKEN_RE = /\G#{TOKEN_RE}/

pp TOKEN_RE




def tokenize( txt )
    tokens_by_line = []

    ### note - start lineno counting at 1 (NOT zero)
    txt.each_line.with_index(1) do |line,lineno|
       tokens = []
       line = line.chomp    ## remove newline
       pos  = 0   ## aka col_start

       puts "==> #{lineno}: >#{line}<"
       while line.length-pos > 0

            m = TOKEN_RE.match( line, pos )

            raise "internal lexer error"  unless m && m.begin(0) == pos

            ## puts "   match #{lineno}@#{m.offset(0)} -- #{m[0]}"

            token  =
            if m[:WHITESPACE]  ## eat-up / ignore
                nil
            elsif m[:COMMENT]
                   ## note - return REM as token type (NOT COMMENT)
                   ##      or eat-up / ignore here in future - why? why not?
                   Token.new( :REM, m[0],
                               lineno: lineno, offset: m.offset(0) )
            elsif m[:KEYWORD]
                   Token.new( m[0].upcase.to_sym, m[0],  ## no value - turn text/lexeme in token type
                              lineno: lineno, offset: m.offset(0) )
            elsif m[:NUMBER]
                   Token.new( :NUMBER, m[0],
                              lineno: lineno, offset: m.offset(0),
                               value: m[0].to_i(10) )
            elsif m[:VARIABLE]
                   Token.new( :VARIABLE, m[0],
                              lineno: lineno, offset: m.offset(0),
                               value: m[0] )
            elsif m[:STRING]
                    ## note - for value - strip enclosing quotes
                   Token.new( :STRING, m[0],
                              lineno: lineno, offset: m.offset(0),
                              value: m[0][1..-2] )
            elsif m[:SYM]
                   Token.new( m[0], m[0],      ## no value - turn text/lexem in token type (keep 'literal string' not symbol)??
                              lineno: lineno, offset: m.offset(0) )
            else
               if m[:ANY]
                 puts "syntax error on line #{lineno}:#{pos+1}"
               else
                 puts "internal lexer error - unhandled token type: #{m}"
               end
               break
            end

            tokens << token   if token

          pos += m[0].length
       end

       tokens << Token.new( "\n", "\n",  lineno: lineno)
       pp tokens

       tokens_by_line << tokens
    end ## each line

    tokens_by_line.flatten
end
end  # class NanoBasicLexer




if __FILE__ == $0

code =  <<BASIC
  10 PRINT "HELLO WORLD"
  20 LET X = 1
  30 PRINT "LOOP NUMBER " + X
  40 LET X = X + 1
  50 IF X < 4 THEN 30
  60 PRINT "DONE!"
  ' CHECK NEGATIVE NUMBER
  70 LET Y = 1 - 1 - - 1
BASIC

=begin
code =  <<BASIC
  10 XPRINT
BASIC

code =  <<BASIC
  10 @ PRINT
BASIC
=end



lexer = NanoBasicLexer.new
tokens = lexer.tokenize(code)

pp tokens

puts "bye"

end
