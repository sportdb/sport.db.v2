
require "strscan"

Token = Struct.new(:type, :value, :offset, keyword_init: true)

class FootballLexer
  SCORE = /
    \d{1,2}-\d{1,2}
    (?:\s+(?:aet|a\.e\.t\.))?
    (?:\s*\(\s*\d{1,2}-\d{1,2}(?:,\s*\d{1,2}-\d{1,2})?\s*\))?
    (?:,\s*\d{1,2}-\d{1,2}\s+pen\.?)?
  /ix


  def initialize(line)
    @s = StringScanner.new(line)
    @tokens = []
  end

  def lex
    skip_space
    return @tokens if @s.eos? || @s.peek(1) == "#"

    lex_date
    lex_time
    lex_match

    skip_space
    raise "Unexpected input: #{@s.rest.inspect}" unless @s.eos?

    @tokens
  end

  private

  def emit(type, value, offset)
    @tokens << Token.new(type: type, value: value, offset: offset)
  end

  def skip_space
    @s.skip(/\s*/)
  end

  def lex_date
    start = @s.pos
    value = @s.scan(/\d{4}-\d{2}-\d{2}/)
    return unless value

    emit(:DATE, value, start)
    skip_space
  end

  def lex_time
    start = @s.pos
    value = @s.scan(/\d{2}:\d{2}/)
    return unless value

    emit(:TIME, value, start)
    skip_space
  end

  def lex_match
    lex_home_team
    lex_separator
    lex_away_team
    lex_score
  end

  def lex_home_team
    start = @s.pos
    value = @s.scan(/.+?(?=\s+v\s+)/)

    raise "Expected home team" unless value

    emit(:TEAM, value.strip, start)
  end

  def lex_separator
    start = @s.pos
    value = @s.scan(/\s+v\s+/)

    raise "Expected 'v' separator" unless value

    emit(:VS, "v", start)
  end

  def lex_away_team
    skip_space

    start = @s.pos
    value = @s.scan(/.+?(?=\s+#{SCORE}\z|\z)/m)

    raise "Expected away team" unless value

    emit(:TEAM, value.strip, start)
  end

  def lex_score
    skip_space

    start = @s.pos
    value = @s.scan(SCORE)
    return unless value

    emit(:SCORE, value, start)
  end
end

if __FILE__ == $PROGRAM_NAME
  ARGV.each do |filename|
    File.foreach(filename) do |line|
      begin
        tokens = FootballLexer.new(line).lex
        puts tokens.inspect unless tokens.empty?
      rescue => e
        warn "#{filename}: #{e.message}"
      end
    end
  end
end
