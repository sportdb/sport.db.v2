
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

  TIME = /\d{1,2}:\d{2}(?:[+-]\d{2}:?\d{2})?/

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

  def initialize(line)
    @scanner = StringScanner.new(line.chomp)
    @tokens = []
    @team = +""
    @team_start = nil
  end

  def tokenize
    lex_date
    lex_time
    lex_match
    flush_team
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
    until @scanner.eos?
      if lex_separator
        next
      elsif lex_score
        next
      else
        append_team_char
      end
    end
  end

  def lex_separator
    start = @scanner.pos

    if @scanner.scan(/\s+v\s+/i)
      flush_team
      emit(:VS, "v", start)
      return true
    end

    if @scanner.scan(/\s+-\s+/)
      flush_team
      emit(:TEAM_SEP, "-", start)
      return true
    end

    false
  end

  def lex_score
    start = @scanner.pos
    value = @scanner.scan(FULL_SCORE)
    return false unless value

    flush_team

    type =
      if value.strip.match?(BASIC_SCORE)
        :SCORE
      else
        :SCORE_FULL
      end

    emit(type, value.strip, start)
    true
  end

  def append_team_char
    char = @scanner.getch

    @team_start ||= @scanner.pos - char.length
    @team << char
  end

  def flush_team
    value = @team.strip

    unless value.empty?
      leading = @team.index(/\S/) || 0
      emit(:TEAM, value, @team_start + leading)
    end

    @team.clear
    @team_start = nil
  end
end
