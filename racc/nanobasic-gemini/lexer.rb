# lexer.rb

require 'strscan'

class NanoBasicLexer
  KEYWORDS = {
    'LET'   => :LET,
    'PRINT' => :PRINT,
    'GOTO'  => :GOTO,
    'IF'    => :IF,
    'THEN'  => :THEN
  }

  def initialize(code)
    @scanner = StringScanner.new(code)
  end

  def tokenize
    tokens = []
    until @scanner.eos?
      @scanner.skip(/\s+/)
      next if @scanner.eos?

      if (num = @scanner.scan(/\d+/))
        tokens << [:NUMBER, num.to_i]
      elsif (str = @scanner.scan(/"([^"\\]|\\.)*"/))
        # Strip the outer double quotes to pass a clean string literal
        tokens << [:STRING, str[1...-1]]
      elsif (word = @scanner.scan(/[A-Za-z]+/))
        type = KEYWORDS[word.upcase] || :IDENTIFIER
        tokens << [type, word]
      elsif @scanner.scan(/==/)
        tokens << [:EQ_COMP, '==']
      elsif @scanner.scan(/=/)
        tokens << [:EQ, '=']
      elsif @scanner.scan(/</)
        tokens << [:LT, '<']
      elsif @scanner.scan(/>/)
        tokens << [:GT, '>']
      elsif @scanner.scan(/\+/)
        tokens << [:PLUS, '+']
      elsif @scanner.scan(/-/)
        tokens << [:MINUS, '-']
      else
        raise "Unexpected symbol: #{@scanner.peek(1)}"
      end
    end
    tokens << [false, false]
    tokens
  end
end
