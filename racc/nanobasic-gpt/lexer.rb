###
##   chatgpt (sept 2026)
##
## q:  if you can start from scratch can you generate / write your ideal NanoBASIC lexer?



# frozen_string_literal: true

#
# NanoBASIC lexer
#
# The lexer works one source line at a time and produces a stream of
# Token objects.  It never skips characters: every character is either
# consumed as part of a token, whitespace/comment, or reported as an error.
#

class Lexer

  Token = Data.define(:type, :text, :value, :lineno, :start, :stop) do
    def inspect
      "#<Token #{type.inspect} #{text.inspect} " \
        "@#{lineno}:#{start}..#{stop}>"
    end
  end

  # ------------------------------------------------------------------
  # Token patterns
  #
  # Order matters:
  #   * comments before variables
  #   * keywords before variables
  #   * multi-character operators before their prefixes
  # ------------------------------------------------------------------

  TOKEN_RE = Regexp.union(

    # Comment.  REM must be a complete word, so REMARK is a variable.
    %r{(?<COMMENT> rem\b.*)}i,
    %r{(?<COMMENT_APOSTROPHE> '.*)},

    # Spaces and tabs.  End-of-line is emitted explicitly by the lexer.
    %r{(?<WHITESPACE> [ \t]+)},

    # BASIC keywords.
    %r{
      (?<KEYWORD>
        (?:
          PRINT
        | LET
        | IF
        | THEN
        | ELSE
        | GOTO
        | GOSUB
        | RETURN
        | FOR
        | TO
        | STEP
        | NEXT
        | INPUT
        | DIM
        | END
        | STOP
        | RUN
        | LIST
        | NEW
        | CLEAR
      )
      \b
    }ix,

    # String literal.
    #
    # NanoBASIC deliberately has no escape sequences here.
    # A quote terminates the string.
    %r{(?<STRING> "[^"]*")},

    # Numeric literal.
    #
    # The sign is deliberately NOT part of NUMBER.  '-' is a token of
    # its own so that the parser can distinguish unary and binary minus.
    %r{(?<NUMBER> [0-9]+(?:\.[0-9]+)?)},

    # Variable name.
    #
    # Deliberately simple NanoBASIC identifiers:
    #   ABC
    #   X
    #   FOO_BAR
    #
    # If the language wants A1 / ABC123 later, change this independently.
    %r{(?<VARIABLE> [A-Za-z_]+)},

    # Operators and punctuation.
    #
    # Multi-character operators MUST precede their one-character prefixes.
    %r{
      (?<SYMBOL>
          <>
        | <=
        | >=
        | =
        | <
        | >
        | \+
        | -
        | \*
        | /
        | \(
        | \)
        | ,
        | ;
      )
    }x,

    # Anything not recognized above is an error.
    %r{(?<INVALID> .)}
  )

  # \G is important:
  #
  # Regexp#match(string, pos) may otherwise search forward from pos.
  # \G makes every token begin exactly where the previous token ended.
  TOKEN_RE = /\G#{TOKEN_RE}/

  KEYWORDS = %w[
    PRINT LET IF THEN ELSE GOTO GOSUB RETURN
    FOR TO STEP NEXT INPUT DIM END STOP
    RUN LIST NEW CLEAR
  ].to_h { |word| [word.upcase, word] }.freeze

  class LexerError < StandardError
    attr_reader :lineno, :position, :text

    def initialize(message, lineno:, position:, text:)
      @lineno = lineno
      @position = position
      @text = text

      super("#{message} at line #{lineno}, column #{position + 1}: #{text.inspect}")
    end
  end

  def initialize(source)
    @source = source
  end

  def tokens
    result = []

    @source.each_line.with_index(1) do |line, lineno|
      result.concat(tokenize_line(line.chomp, lineno))
      result << Token.new("\n", "\n", "\n", lineno, line.chomp.length, line.chomp.length)
    end

    result
  end

  private

  def tokenize_line(line, lineno)
    tokens = []
    pos = 0

    while pos < line.length

      match = TOKEN_RE.match(line, pos)

      unless match
        raise LexerError.new(
          "internal lexer error",
          lineno: lineno,
          position: pos,
          text: line[pos..]
        )
      end

      # Defensive assertion documenting the lexer invariant.
      unless match.begin(0) == pos
        raise LexerError.new(
          "lexer skipped input",
          lineno: lineno,
          position: pos,
          text: match[0]
        )
      end

      text = match[0]
      start_pos = pos
      stop_pos  = pos + text.length

      if match[:INVALID]
        raise LexerError.new(
          "unexpected character",
          lineno: lineno,
          position: pos,
          text: text
        )
      end

      if match[:WHITESPACE]
        pos = stop_pos
        next
      end

      if match[:COMMENT] || match[:COMMENT_APOSTROPHE]
        # A comment consumes the rest of the source line.
        pos = stop_pos
        break
      end

      type, value =
        if match[:KEYWORD]
          [match[:KEYWORD].upcase, match[:KEYWORD].upcase]

        elsif match[:STRING]
          # Remove the surrounding quotes.
          [:STRING, match[:STRING][1...-1]]

        elsif match[:NUMBER]
          text = match[:NUMBER]

          if text.include?(".")
            [:NUMBER, text.to_f]
          else
            [:NUMBER, text.to_i]
          end

        elsif match[:VARIABLE]
          [:VARIABLE, match[:VARIABLE].upcase]

        elsif match[:SYMBOL]
          # Symbolic tokens use their source spelling as their type.
          [match[:SYMBOL], match[:SYMBOL]]

        else
          raise LexerError.new(
            "unknown token",
            lineno: lineno,
            position: pos,
            text: text
          )
        end

      tokens << Token.new(
        type,
        text,
        value,
        lineno,
        start_pos,
        stop_pos
      )

      pos = stop_pos
    end

    tokens
  end
end
