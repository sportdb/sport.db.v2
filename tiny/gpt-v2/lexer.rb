
require "strscan"

Token = Struct.new(:type, :value, :offset, keyword_init: true)

class FootballLexer
  BASIC_SCORE = /\d{1,2}-\d{1,2}/

  FULL_SCORE = /
    \d{1,2}-\d{1,2}
    (?:\s+(?:aet|a\.e\.t\.))?
    (?:\s*\([^)]*\))?
    (?:\s*,\s*\d{1,2}-\d{1,2}\s*(?:pen(?:s)?\.?)?)?
  /ix

  DATE = /
    \d{4}-\d{1,2}-\d{1,2} |
    \d{1,2}[.\/-]\d{1,2}[.\/-]\d{2,4} |
    (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)[a-z]*,?\s+
      (?:\d{1,2}\s+)?
      (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*
      \s+\d{1,2}(?:,?\s+\d{4})? |
    (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*
      \s+\d{1,2}(?:,?\s+\d{4})?
  /ix

  TIME = /\d{1,2}:\d{2}(?:[+-]\d{2}:?\d{2})?/



## use/add non-greedy qualifier ???
# Team name: non-whitespace words separated by exactly one space.
TEAM_NAME = /[^\s]+
             (?:
                 [ ] [^\s]+
             )*?
            /ix

# A team token must end at a structural boundary.
# Team ends immediately before one of these markers.
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


AWAY_TEAM = /
  #{TEAM_NAME}
  (?=
    \s+#{FULL_SCORE}
    |
    \z
  )
/ix




  def initialize(line)
    @scanner = StringScanner.new(line.chomp)
    @tokens = []
  end

  def tokenize
    lex_date
    lex_time
    lex_match
    @tokens
  end

  private

  def emit(type, value, offset)
    @tokens << Token.new(type: type, value: value, offset: offset)
  end

  def skip_space
    @scanner.skip(/\s+/)
  end

  def lex_date
    skip_space
    start = @scanner.pos
    value = @scanner.scan(DATE)
    return unless value

    emit(:DATE, value, start)
    skip_space
  end

  def lex_time
    skip_space
    start = @scanner.pos
    value = @scanner.scan(TIME)
    return unless value

    emit(:TIME, value, start)
    skip_space
  end




def lex_match
  skip_space

  # 1. Home team
  start = @scanner.pos
  home = @scanner.scan(HOME_TEAM)

  unless home
    raise "Expected home team at #{@scanner.pos}: #{@scanner.rest.inspect}"
  end

  emit(:TEAM, home, start)


  # 2. Match separator format:
  #    Home v Away [Score]
  #    Home - Away [Score]
  if lex_separator
    lex_away_team
    lex_score
    return
  end

  # 3. Score-before-away format:
  #    Home Score Away
  #    Home FullScore Away
  if lex_score
    lex_away_team
    return
  end

  # 4. Home-only fixture, or malformed/incomplete input
  unless @scanner.eos?
    raise "Unexpected input at #{@scanner.pos}: #{@scanner.rest.inspect}"
  end
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


  def lex_separator
    start = @scanner.pos

    if @scanner.scan(/\s+v\s+/i)
      emit(:VS, "v", start)
      return true
    end

    if @scanner.scan(/\s+-\s+/)
      emit(:TEAM_SEP, "-", start)
      return true
    end

    false
  end

  def lex_score
    skip_space

    start = @scanner.pos
    value = @scanner.scan(FULL_SCORE)
    return false unless value

    type =
      if value.strip.match?(BASIC_SCORE)
        :SCORE
      else
        :SCORE_FULL
      end

    emit(type, value.strip, start)
    true
  end

end