
require "strscan"

Token = Struct.new(:type, :value, :offset, keyword_init: true)

# ------------------------------------------------------------
# Scores
# ------------------------------------------------------------

BASIC_SCORE = /\d{1,2}-\d{1,2}/

FULL_SCORE = /
  #{BASIC_SCORE}
  (?:\s+(?:a\.e\.t\.?|aet|et))?
  (?:\s*\(\s*#{BASIC_SCORE}(?:,\s*#{BASIC_SCORE})?\s*\))?
  (?:,\s*\d{1,2}-\d{1,2}\s+pen\.?)?
/ix

# ------------------------------------------------------------
# Dates and times (initial subset)
# ------------------------------------------------------------

DATE = /
  \d{4}-\d{2}-\d{2}              # 2025-08-15
  |
  \d{1,2}[.\/-]\d{1,2}[.\/-]\d{4} # 15.08.2025
  |
  \d{1,2}\s+[A-Za-z]+\s+\d{4}  # 15 August 2025
/ix

TIME = /\d{1,2}:\d{2}/

# ------------------------------------------------------------
# Team names
# ------------------------------------------------------------

## use/add non-greedy qualifier ???
# Team name: non-whitespace words separated by exactly one space.
TEAM_NAME = /[^\s]+
             (?:
                 [ ] [^\s]+
             )*?
            /ix



# A home team ends before the separator, a score, or end of line.
HOME_TEAM = /
  #{TEAM_NAME}
  (?=
    \s+v\s+
    |
    \s+-\s+
    |
    \s+#{FULL_SCORE}
    |
    \z
  )
/ix

# An away team ends before a trailing score or end of line.
AWAY_TEAM = /
  #{TEAM_NAME}
  (?=
    \s+#{FULL_SCORE}
    |
    \z
  )
/ix

# ------------------------------------------------------------
# Lexer
# ------------------------------------------------------------

class FootballLexer
  attr_reader :tokens

  def initialize(line)
    @scanner = StringScanner.new(line.strip)
    @tokens = []
  end

  def lex
    lex_date
    lex_time
    lex_match
    tokens
  end

  private

  def emit(type, value, offset)
    tokens << Token.new(type: type, value: value, offset: offset)
  end

  def skip_space
    @scanner.skip(/\s*/)
  end

  # Optional leading date
  def lex_date
    skip_space
    start = @scanner.pos
    value = @scanner.scan(DATE)
    return unless value

    emit(:DATE, value, start)
    skip_space
  end

  # Optional kickoff time
  def lex_time
    skip_space
    start = @scanner.pos
    value = @scanner.scan(TIME)
    return unless value

    emit(:TIME, value, start)
    skip_space
  end

  # Match forms:
  #   Home v Away
  #   Home v Away 2-1
  #   Home - Away 2-1
  #   Home 2-1 Away
  def lex_match
    skip_space

    start = @scanner.pos
    home = @scanner.scan(HOME_TEAM)

    unless home
      raise "Expected home team at #{@scanner.pos}: #{@scanner.rest.inspect}"
    end

    emit(:TEAM, home, start)

    # Separator forms: home v away / home - away
    if lex_separator
      lex_away_team
      lex_score
      return
    end

    # Score-first form: home 2-1 away
    if lex_score
      lex_away_team
      return
    end

    # Team-only input
    return if @scanner.eos?

    raise "Unexpected input at #{@scanner.pos}: #{@scanner.rest.inspect}"
  end

  def lex_separator
    start = @scanner.pos
    value = @scanner.scan(/\s+(v|-)\s+/i)
    return false unless value

    separator = value.strip.downcase
    type = separator == "v" ? :VS : :TEAM_SEP

    emit(type, separator, start)
    true
  end

  def lex_away_team
    skip_space

    start = @scanner.pos
    away = @scanner.scan(AWAY_TEAM)

    unless away
      raise "Expected away team at #{@scanner.pos}: #{@scanner.rest.inspect}"
    end

    emit(:TEAM, away, start)
  end

  def lex_score
    skip_space

    start = @scanner.pos
    value = @scanner.scan(FULL_SCORE)
    return false unless value

    type = value.match?( /\A#{BASIC_SCORE}\z/ ) ? :SCORE : :SCORE_FULL
    emit(type, value, start)

    true
  end
end

# ------------------------------------------------------------
# Line-by-line usage
# ------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  ARGV.each do |filename|
    File.foreach(filename) do |line|
      next if line.strip.empty?
      next if line.strip.start_with?("#")

      begin
        lexer = FootballLexer.new(line)
        puts lexer.lex.inspect
      rescue => e
        warn "#{filename}: #{e.message}"
      end
    end
  end
end
