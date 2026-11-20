
# nano_football_lexer.rb

require "strscan"
require "date"

class NanoFootballLexer
  Token = Struct.new(
    :type, :value, :line, :column,
    keyword_init: true
  ) do
    def inspect
      "#<#{type} #{value.inspect} @#{line}:#{column}>"
    end
  end

  class LexError < StandardError
    attr_reader :line, :column

    def initialize(message, line, column)
      @line = line
      @column = column
      super("#{message} at #{line}:#{column}")
    end
  end

  SCORE_RE = /\d+\s*-\s*\d+/
  DATE_RE  = /\d{4}-\d{2}-\d{2}/
  TIME_RE  = /\d{2}:\d{2}/

  def initialize(source)
    @source = source
    @tokens = []
  end

  def tokenize
    @tokens = []

    @source.each_line.with_index(1) do |line, line_number|
      scan_line(line.chomp, line_number)
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

  def error(message, line, column)
    raise LexError.new(message, line, column)
  end

  def scan_line(text, line_number)
    scanner = StringScanner.new(text)

    scanner.skip(/\s*/)
    return if scanner.eos?

    column = scanner.pos + 1

    # Comment
    if scanner.scan(/#/)
      emit(:COMMENT, scanner.rest.strip,
           line_number, column)
      return
    end

    # Competition header: = Premier League
    if scanner.scan(/=/)
      value = scanner.rest.strip

      error("Empty competition header", line_number, column) if value.empty?

      emit(:COMPETITION, value, line_number, column)
      return
    end

    # Round header: ▪ Round 1
    if scanner.scan(/▪/)
      value = scanner.rest.strip

      error("Empty round header", line_number, column) if value.empty?

      emit(:ROUND, value, line_number, column)
      return
    end

    scan_fixture(scanner, line_number)
  end

  def scan_fixture(scanner, line_number)
    # Optional date
    if (value = scanner.scan(DATE_RE))
      validate_date(value, line_number, scanner.pos - value.length + 1)
      emit(:DATE, value, line_number, scanner.pos - value.length + 1)
      scanner.skip(/\s+/)
    end

    # Optional kickoff time
    if (value = scanner.scan(TIME_RE))
      validate_time(value, line_number, scanner.pos - value.length + 1)
      emit(:TIME, value, line_number, scanner.pos - value.length + 1)
      scanner.skip(/\s+/)
    end

    fixture_column = scanner.pos + 1

    # Scan home team and separator.
    # The separator must be surrounded by whitespace.
    home_with_separator = scanner.scan_until(/\s+v\s+/)

    unless home_with_separator
      error("Expected team separator ' v '",
            line_number, fixture_column)
    end

    # Remove separator from scanned text.
    home = home_with_separator.sub(/\s+v\s+\z/, "").strip

    if home.empty?
      error("Missing home team", line_number, fixture_column)
    end

    separator_length = home_with_separator.length -
                       home_with_separator.sub(/\s+v\s+\z/, "").length

    home_column = fixture_column
    emit(:TEAM_NAME, home, line_number, home_column)

    vs_column = fixture_column +
                home_with_separator.sub(/\s+v\s+\z/, "").length +
                home_with_separator[/\s+v\s+\z/].index("v")

    emit(:VS, "v", line_number, vs_column + 1)

    away_column = scanner.pos + 1

    away_and_score = scanner.rest.strip

    if away_and_score.empty?
      error("Missing away team", line_number, away_column)
    end

    # Identify an optional result at the end of the line.
    away, score_text = split_score(away_and_score)

    if away.nil? || away.empty?
      error("Missing away team", line_number, away_column)
    end

    emit(:TEAM_NAME, away, line_number, away_column)

    if score_text
      scan_score(score_text, line_number,
                 away_column + away.length)
    end
  end

  def split_score(text)
    # Score must be a trailing result, not part of a team name.
    #
    # Examples:
    # Chelsea 2-1
    # Chelsea 2-1 (1-0)
    # Chelsea 2-2 aet
    # Chelsea 2-2 aet (1-1, 0-0), 5-4 pen.

    pattern = /
      \A
      (?<away>.*?)
      \s+
      (?<score>\d+\s*-\s*\d+)
      (?<details>
        \s*
        (?:a\.?e\.?t\.?)?
        \s*
        (?:\([^)]*\))?
        \s*
        (?:,\s*\d+\s*-\s*\d+\s+pen\.?)?
      )?
      \s*
      \z
    /ix

    match = pattern.match(text)
    return [text, nil] unless match

    [match[:away].strip,
     match[:score] + match[:details].to_s]
  end

  def scan_score(text, line_number, start_column)
    scanner = StringScanner.new(text)

    scanner.skip(/\s*/)

    # Full-time score
    score = scanner.scan(SCORE_RE)

    error("Invalid score", line_number, start_column) unless score

    emit(:SCORE, score, line_number, start_column)

    # Optional extra time marker
    scanner.skip(/\s*/)

    if (aet = scanner.scan(/a\.?e\.?t\.?/i))
      emit(:AET, aet, line_number,
           start_column + scanner.pos - aet.length)
    end

    scanner.skip(/\s*/)

    # Optional score details (e.g. half-time)
    if (details = scanner.scan(/\([^)]*\)/))
      emit(:SCORE_DETAILS, details, line_number,
           start_column + scanner.pos - details.length)
    end

    scanner.skip(/\s*/)

    # Optional penalty shootout
    if scanner.scan(/,/)
      scanner.skip(/\s*/)

      penalty = scanner.scan(SCORE_RE)

      error("Expected penalty score", line_number,
            start_column + scanner.pos) unless penalty

      emit(:PENALTY_SCORE, penalty, line_number,
           start_column + scanner.pos - penalty.length)

      scanner.skip(/\s*/)

      unless scanner.scan(/pen\.?/i)
        error("Expected 'pen.' after penalty score",
              line_number, start_column + scanner.pos)
      end
    end

    scanner.skip(/\s*/)

    unless scanner.eos?
      error("Unexpected score text: #{scanner.rest.inspect}",
            line_number, start_column + scanner.pos)
    end
  end

  def validate_date(value, line, column)
    Date.iso8601(value)
  rescue Date::Error
    error("Invalid date #{value.inspect}", line, column)
  end

  def validate_time(value, line, column)
    hour, minute = value.split(":").map(&:to_i)

    return if hour.between?(0, 23) &&
              minute.between?(0, 59)

    error("Invalid time #{value.inspect}", line, column)
  end
end
