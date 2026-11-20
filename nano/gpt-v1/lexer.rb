
# nano_football_lexer.rb

class NanoFootballLexer
  Token = Struct.new(:type, :value, :line, :column, keyword_init: true) do
    def to_s
      "#{type}(#{value.inspect}) at #{line}:#{column}"
    end
  end

  class LexError < StandardError; end

  SCORE_RE = /
    \s+
    (?<score>\d+\s*-\s*\d+)
    (?<tail>
      (?:\s+aet)?
      (?:\s*\([^)]*\))?
      (?:,\s*\d+\s*-\s*\d+\s+pen\.?)?
    )
    \s*\z
  /ix

  def initialize(source)
    @source = source
    @tokens = []
  end

  def tokenize
    @tokens = []

    @source.each_line.with_index(1) do |line, line_no|
      lex_line(line.chomp, line_no)
    end

    @tokens
  end

  private

  def emit(type, value, line, column)
    @tokens << Token.new(
      type: type,
      value: value,
      line: line,
      column: column
    )
  end

  def lex_line(line, line_no)
    stripped = line.strip

    # Blank lines
    return if stripped.empty?

    # Comments
    if stripped.start_with?('#')
      column = line.index('#') + 1
      emit(:COMMENT, stripped[1..].strip, line_no, column)
      return
    end

    offset = line.index(/\S/)

    # Optional date
    if (m = stripped.match(/\A(\d{4}-\d{2}-\d{2})\b/))
      emit(:DATE, m[1], line_no, offset + 1)
      stripped = stripped[m[0].length..].lstrip
      offset = line.index(stripped, offset)
    end

    # Optional kickoff time
    if (m = stripped.match(/\A(\d{2}:\d{2})\b/))
      emit(:TIME, m[1], line_no, offset + 1)
      stripped = stripped[m[0].length..].lstrip
      offset = line.index(stripped, offset) || line.length
    end

    # Find the team separator
    separator = /\s+v\s+/.match(stripped)

    unless separator
      raise LexError,
        "Expected ' v ' at line #{line_no}: #{line.inspect}"
    end

    home = stripped[0...separator.begin(0)].strip
    away = stripped[separator.end(0)..].strip

    if home.empty? || away.empty?
      raise LexError, "Missing team name at line #{line_no}"
    end

    home_column = line.index(home, offset) + 1
    emit(:HOME_TEAM, home, line_no, home_column)

    v_column = line.index('v', offset + home.length) + 1
    emit(:VS, 'v', line_no, v_column)

    away_column = line.index(away, v_column) || 0

    # Extract an optional trailing result
    score_match = SCORE_RE.match(" #{away}")

    if score_match
      score = score_match[:score]
      tail = score_match[:tail]

      # Remove the result from the away team name
      score_start = score_match.begin(:score) - 1
      away_team = away[0...score_start].strip

      emit(:AWAY_TEAM, away_team, line_no, away_column + 1)

      score_column = line.index(score, away_column) + 1
      emit(:SCORE, score, line_no, score_column)

      # Extra time
      if tail.match?(/\baet\b/i)
        aet_column = line.index('aet', score_column - 1) + 1
        emit(:AET, 'aet', line_no, aet_column)
      end

      # Additional score details, e.g. half-time score
      if (details = tail.match(/\([^)]*\)/))
        details_column = line.index(details[0], score_column - 1) + 1
        emit(:DETAILS, details[0], line_no, details_column)
      end

      # Penalty shootout
      if (pen = tail.match(/,\s*(\d+\s*-\s*\d+)\s+pen\.?/i))
        pen_column = line.index(pen[1], score_column - 1) + 1
        emit(:PENALTIES, pen[1], line_no, pen_column)
      end
    else
      emit(:AWAY_TEAM, away, line_no, away_column + 1)
    end
  end
end
