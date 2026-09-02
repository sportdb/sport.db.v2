# NanoBASIC/tokenizer.rb



class Token
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
        q.text( @type )
        q.text( " " )
        q.pp( @text )
        q.text( " @#{@lineno},#{@offset.join(':')}")
        if @value
         q.text( " " )
         q.pp( @value )
        end
  end
end
end   ## class Token


######
## difference to "upstream" lexer
##    add optional ' for REM e.g.
##      REM  check negative numbers or
##      '    check negative numbers
##
##    remove -? from NUMBER (handled by MINUS)
##    whitespace - handles multiple spaces/tabs (BUT no newline)



TOKEN_RE = Regexp.union(
    %r{   (?<COMMENT>      (?: rem \b |') .*  )}ix,
    %r{   (?<WHITESPACE>   [ \t\n]+   )}x,
    %r{   (?<KEYWORD>   (?:
                        print
                      | if
                      | then
                      | let
                      | goto
                      | gosub
                      | return) \b ) }ix,   ## check add word boundray - why? why not
                                            ##  e.g.  will print match println ???

    %r{      (?<COMMA> ,)
           | (?<EQUAL> =)
           | (?<NOT_EQUAL> <> )      ## not - drop ><
           | (?<LESS_EQUAL>  <=)
           | (?<LESS> <)
           | (?<GREATER_EQUAL> >=)
           | (?<GREATER> >)
           | (?<PLUS> \+)
           | (?<MINUS> -)
           | (?<MULTIPLY>    \*  )
           | (?<DIVIDE>      /   )
           | (?<OPEN_PAREN>  \(  )
           | (?<CLOSE_PAREN> \)  )}x,

    %r{  (?<VARIABLE>   [A-Za-z_]+ )}x,
    %r{  (?<NUMBER>    [0-9]+ )}x,      ## note -   -? handled/matched by MINUS
    %r{  (?<STRING>   "[^"]*") }x,

    %r{   (?<ANY> . ) }x   ## last - catch all/fall back for any character
    )


pp TOKEN_RE


def tokenize( txt )
    tokens = []
    txt.each_line.with_index(1) do |line,lineno|
       line = line.chomp    ## remove newline
       pos  = 0   ## aka col_start

       puts " #{lineno}: >#{line}<"
       while line.length-pos > 0
            m = TOKEN_RE.match( line, pos )

            raise "internal lexer error"  unless m && m.begin(0) == pos
            ## hack: convert captures to hash (should only have single entry/capture)
            ## or use
            ##  type, _text = m.named_captures.find { |_name, text| text }
            type, _text = m.named_captures(symbolize_names: true).compact.first

            puts "#{type} #{m[0]} #{lineno}@#{m.offset(0)}"
            case type
            when :ANY
               puts "Syntax error on line #{lineno}:#{pos+1}"
               break
            when :COMMENT       ## eat-up
            when :WHITESPACE    ## eat-up
            when :KEYWORD
                tokens << Token.new( m[0].upcase.to_sym, m[0],
                                       lineno: lineno, offset: m.offset(0) )
            when :NUMBER
                tokens << Token.new( :NUMBER, m[0],
                                        lineno: lineno, offset: m.offset(0),
                                        value: m[0].to_i(10)  )
            when :VARIABLE
                tokens << Token.new( :VARIABLE, m[0],
                                         lineno: lineno, offset: m.offset(0),
                                         value: m[0]  )
            when :STRING
                ## note - for value - strip enclosing quotes
                tokens << Token.new( :STRING, m[0],
                                         lineno: lineno, offset: m.offset(0),
                                         value: m[0][1..-2]  )
            else  ## assume literal/terminal
                tokens << Token.new( type, m[0],
                                       lineno: lineno, offset: m.offset(0) )
            end
          pos += m[0].length
       end
    end ## each line
    tokens
end





tokens = tokenize( <<BASIC )
  10 PRINT "HELLO WORLD"
  20 LET X = 1
  30 PRINT "LOOP NUMBER " + X
  40 LET X = X + 1
  50 IF X < 4 THEN 30
  60 PRINT "DONE!"
  ' CHECK NEGATIVE NUMBER
  70 LET Y = 1 - 1 - - 1
BASIC


pp tokens





puts "bye"
