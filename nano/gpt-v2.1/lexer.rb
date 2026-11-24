
require "strscan"

class NanoLexer
  Token = Struct.new(
    :type,
    :value,
    :line,
    :column,
    keyword_init: true
  )

  # ------------------------------------------------------------
  # Regular expressions
  # ------------------------------------------------------------

  WHITESPACE = /[ \t]*/

  BLANK_LINE = /\A[ \t]*\z/
  COMMENT    = /\A[ \t]*#/

  HEADING = /\A[ \t]*(=+)[ \t]*(.*?)\s*\z/
  ROUND   = /\A[ \t]*▪[ \t]*(.*?)\s*\z/

  DATE = /\d{4}-\d{2}-\d{2}(?!\d)/
  TIME = /\d{2}:\d{2}(?!\d)/

  # Match separator. Captures the actual "v".
  VS = /([ \t]+)(v)([ \t]+)/i

  # Score components
  RESULT = '\d+\s*-\s*\d+'
  AET    = 'a\.?e\.?t\.?'
  PEN    = '(?:pen\.?|p)'

  SCORE_DETAILS = /
    \(
      \s*#{RESULT}
      (?:\s*,\s*#{RESULT})?
      \s*
    \)
  /x

  # All score variations documented in Nano:
  #
  # 1-1
  # 1-1 (0-1)
  # 1-1 aet
  # 1-1 aet (1-1)
  # 1-1 aet (1-1, 0-0)
  # 1-1 aet, 3-4 pen
  # 1-1, 3-4 pen
  # 3-4 pen

  SCORE = /
    (?:
      #{RESULT}
      (?:\s*#{AET})?
      (?:\s*#{SCORE_DETAILS})?
      (?:\s*,\s*#{RESULT}\s*#{PEN})?
      |
      #{RESULT}\s*,\s*#{RESULT}\s*#{PEN}
      |
      #{RESULT}\s*#{PEN}
    )
    (?![\w])
  /ix

  STATUS = /\[[^\]]*\]/
  VENUE  = /@.*\z/

  # Away team ends when score, status or venue starts.
  AWAY_TEAM = /
    .*?
    (?=
      [ \t]+
      (?:
        #{SCORE.source}
        |
        \[
        |
        @
      )
      |
      \z
    )
  /ix

  attr_reader :tokens

  def initialize(source)
    @source = source
    @tokens = []
    @line_number = 0
    @line = ""
  end

  # ------------------------------------------------------------
  # Public API
  # ------------------------------------------------------------

  def tokenize
    @source.each_line do |line|
      @line_number += 1
      @line = line.chomp

      tokenize_line
    end

    # EOF position
    @line = ""
    emit(:EOF, nil, 1)

    @tokens
  end

  private

  # ------------------------------------------------------------
  # Token creation
  # ------------------------------------------------------------

  def emit(type, value, byte_column)
    @tokens << Token.new(
      type: type,
      value: value,
      line: @line_number,
      column: column_for(byte_column)
    )
  end

  # StringScanner uses byte offsets. Convert them to
  # 1-based character columns for user-friendly locations.
  def column_for(byte_offset)
    @line.byteslice(0, byte_offset).to_s.each_char.count + 1
  end

  # Emit a token after trimming surrounding whitespace.
  # The original source position is preserved.
  def emit_trimmed(type, value, byte_offset)
    leading = value[/\A[ \t]*/].to_s.bytesize
    value = value.strip

    return if value.empty?

    emit(type, value, byte_offset + leading)
  end

  # Scan a token and emit it automatically.
  def scan_token(scanner, type, pattern, &transform)
    start = scanner.pos
    value = scanner.scan(pattern)

    if value
      value = transform.call(value) if transform
      emit(type, value, start)
    end

    value
  end

  # ------------------------------------------------------------
  # Line handling
  # ------------------------------------------------------------

  def tokenize_line
    return if @line.match?(BLANK_LINE)
    return if @line.match?(COMMENT)

    scanner = StringScanner.new(@line)

    if scanner.scan(HEADING)
      marker_column = scanner.pre_match.bytesize
      emit(:HEADING, scanner[2], marker_column + 1)
      return
    end

    scanner.reset

    if scanner.scan(ROUND)
      marker_column = scanner.pre_match.bytesize
      emit(:ROUND, scanner[1], marker_column + 1)
      return
    end

    scanner.reset
    scanner.skip(WHITESPACE)

    # Optional date
    if scan_token(scanner, :DATE, DATE)
      scanner.skip(WHITESPACE)

      # A standalone date header
      return if scanner.eos?
    end

    # Optional time
    scan_token(scanner, :TIME, TIME)
    scanner.skip(WHITESPACE)

    return if scanner.eos?

    parse_match(scanner)
  end

  # ------------------------------------------------------------
  # Match parsing
  # ------------------------------------------------------------

  def parse_match(scanner)
    # Home team and "v" separator
    match_start = scanner.pos
    separator = scanner.scan_until(VS)

    unless separator
      emit(:ERROR, scanner.rest.strip, match_start)
      return
    end

    separator_length = scanner.matched.bytesize
    home = separator.byteslice(0, separator.bytesize - separator_length)

    emit_trimmed(:TEAM, home, match_start)

    # Position of the actual "v"
    separator_start = scanner.pos - separator_length
    v_offset = separator_start + scanner[1].bytesize

    emit(:VS, "v", v_offset)

    # Away team
    away_start = scanner.pos
    away = scanner.scan(AWAY_TEAM)

    unless away && !away.strip.empty?
      emit(:ERROR, "Missing away team", away_start)
      return
    end

    emit_trimmed(:TEAM, away, away_start)

    scanner.skip(WHITESPACE)

    # Optional score
    scan_token(scanner, :SCORE, SCORE) do |value|
      value.strip
    end

    scanner.skip(WHITESPACE)

    # Optional status
    scan_token(scanner, :STATUS, STATUS) do |value|
      value[1...-1]
    end

    scanner.skip(WHITESPACE)

    # Optional venue
    scan_token(scanner, :VENUE, VENUE) do |value|
      value.sub(/\A@\s*/, "").strip
    end

    scanner.skip(WHITESPACE)

    # Report anything not recognized
    unless scanner.eos?
      emit(:ERROR, scanner.rest.strip, scanner.pos)
    end
  end
end
