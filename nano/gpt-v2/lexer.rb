
require "strscan"

class NanoLexer
  Token = Struct.new(:type, :value, :line, keyword_init: true)

  SCORE_RE = /
    \d+\s*-\s*\d+
    (?:\s*(?:a\.?e\.?t\.?))?
    (?:\s*\(\s*\d+\s*-\s*\d+
        (?:\s*,\s*\d+\s*-\s*\d+)?\s*\))?
    (?:\s*,?\s*\d+\s*-\s*\d+\s*(?:pen\.?|p))?
  /ix

  attr_reader :tokens

  def initialize(source)
    @source = source
    @tokens = []
    @line_number = 0
  end

  def tokenize
    scanner = StringScanner.new(@source)

    until scanner.eos?
      line = scanner.scan_until(/\n/) || scanner.rest
      @line_number += 1

      line = line.chomp
      tokenize_line(line)
    end

    emit(:EOF, nil)
    @tokens
  end

  private

  def emit(type, value)
    @tokens << Token.new(
      type: type,
      value: value,
      line: @line_number
    )
  end

  def tokenize_line(line)
    scanner = StringScanner.new(line)

    # Ignore blank lines and comments
    return if line.strip.empty?
    return if line.lstrip.start_with?("#")

    # Competition / document heading
    if scanner.scan(/\s*(=+)\s*(.+?)\s*/)
      emit(:HEADING, scanner[2])
      return
    end

    # Round / stage / group
    if scanner.scan(/\s*▪\s*(.+?)\s*/)
      emit(:ROUND, scanner[1])
      return
    end

    scanner.reset

    # Standalone date or date at beginning of match line
    date = scanner.scan(/\s*\d{4}-\d{2}-\d{2}/)

    if date
      date = date.strip
      emit(:DATE, date)

      # A standalone date header
      if scanner.eos?
        return
      end
    end

    # Optional kickoff time
    time = scanner.scan(/\s*\d{2}:\d{2}/)

    if time
      emit(:TIME, time.strip)
    end

    # Parse match
    parse_match(scanner)
  end

  def parse_match(scanner)
    # Find the separator between home and away teams
    separator = scanner.scan_until(/\s+v\s+/i)

    unless separator
      emit(:ERROR, scanner.rest.strip)
      return
    end

    home = separator.sub(/\s+v\s+$/i, "").strip
    emit(:TEAM, home)
    emit(:VS, "v")

    # Find where the away team ends.
    # Metadata starts with a score, status or venue.
    away = scanner.scan(
      /.*?(?=\s+(?:\d+\s*-\s*\d+|\[|@))/
    )

    away ||= scanner.rest

    emit(:TEAM, away.strip) unless away.strip.empty?

    scanner.skip(/\s*/)

    # Optional score, including score details and penalties
    score = scanner.scan(SCORE_RE)

    if score
      emit(:SCORE, score.strip)
    end

    scanner.skip(/\s*/)

    # Optional match status
    status = scanner.scan(/\[[^\]]*\]/)

    if status
      emit(:STATUS, status[1...-1].strip)
    end

    scanner.skip(/\s*/)

    # Optional venue / geographical tree
    venue = scanner.scan(/@\s*.+/)

    if venue
      emit(:VENUE, venue.sub(/^@\s*/, "").strip)
    end

    scanner.skip(/\s*/)

    # Anything left over is probably malformed input
    unless scanner.eos?
      emit(:ERROR, scanner.rest.strip)
    end
  end
end
