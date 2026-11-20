################
# football_lexer.rb


Token = Struct.new(:type, :value, :offset, keyword_init: true)

class FootballLexer
  # Scores:
  #   2-1
  #   2-1 aet
  #   2-1 (1-0)
  #   2-1 a.e.t. (1-1, 0-0)
  #   2-2 a.e.t. (1-1, 0-0), 5-4 pen.
  #
  # Penalty score and extra-time/HT information are kept
  # as part of SCORE_FULL rather than split into sub-tokens.

  SCORE_RE = /
    \d{1,2}-\d{1,2}
    (?:
      \s*(?:a\.e\.t\.?|aet|agget|asdet|asget|aet\/gg|a\.e\.t\.\/g\.g\.?)
    )?
    (?:
      \s*\([^)]*\)
    )?
    (?:
      \s*,?\s*\d{1,2}-\d{1,2}\s*(?:pen(?:s)?\.?)?
    )?
  /ix

  # A subset of Football.TXT date forms.
  DATE_RE = /
    \d{4}-\d{1,2}-\d{1,2} |
    \d{1,2}[.\/-]\d{1,2}[.\/-]\d{2,4} |
    (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)
      (?:day)?[,]?\s+
      (?:\d{1,2}\s+)?
      (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)
      [a-z]*\s+\d{1,2}(?:,?\s+\d{2,4})? |
    (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)
      [a-z]*\s+\d{1,2}(?:,?\s+\d{2,4})?
  /ix

  TIME_RE = /\d{1,2}:\d{2}(?:[+-]\d{2}:?\d{2})?/

  SEPARATOR_RE = /
    \s+v\s+ |
    \s+-\s+
  /ix

  def initialize(line)
    @line = line.chomp
    @pos = 0
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

  def skip_spaces
    @pos += 1 while @pos < @line.length && @line[@pos] =~ /\s/
  end

  # Optional date at the beginning of the line.
  def lex_date
    skip_spaces
    match = DATE_RE.match(@line[@pos..])

    return unless match

    value = match[0]
    emit(:DATE, value, @pos)
    @pos += value.length
    skip_spaces
  end

  # Optional kick-off time immediately after the date (or at line start).
  def lex_time
    skip_spaces
    match = TIME_RE.match(@line[@pos..])

    return unless match

    value = match[0]
    emit(:TIME, value, @pos)
    @pos += value.length
    skip_spaces
  end

  def lex_match
    body = @line[@pos..]
    base_offset = @pos

    # Try separator-based syntax first:
    #   Team v Team [Score]
    #   Team - Team [Score]
    separator = find_separator(body)

    if separator
      left = body[0...separator.begin(0)].strip
      sep_text = separator[0].strip
      right = body[separator.end(0)..].strip

      emit(:TEAM, left, base_offset) unless left.empty?
      emit_separator(sep_text, base_offset + separator.begin(0))

      # A trailing score belongs to the right-hand side.
      score_match = trailing_score(right)

      if score_match
        team = right[0...score_match.begin(0)].strip
        score = score_match[0].strip

        emit(:TEAM, team, base_offset + separator.end(0)) unless team.empty?
        emit_score(score, base_offset + separator.end(0) + team.length)
      else
        emit(:TEAM, right, base_offset + separator.end(0)) unless right.empty?
      end

      return
    end

    # Score-between-teams syntax:
    #   Team 2-1 Team
    #   Team 2-1 (1-0) Team
    score_match = find_score(body)

    if score_match
      left = body[0...score_match.begin(0)].strip
      score = score_match[0].strip
      right = body[score_match.end(0)..].strip

      emit(:TEAM, left, base_offset) unless left.empty?
      emit_score(score, base_offset + score_match.begin(0))
      emit(:TEAM, right, base_offset + score_match.end(0)) unless right.empty?
    else
      # No structural marker found: whole remainder is team text.
      emit(:TEAM, body.strip, base_offset) unless body.strip.empty?
    end
  end

  def find_separator(text)
    text.match(SEPARATOR_RE)
  end

  def emit_separator(text, offset)
    type = text.casecmp("v").zero? ? :VS : :TEAM_SEP
    emit(type, text, offset)
  end

  def find_score(text)
    text.match(SCORE_RE)
  end

  def trailing_score(text)
    # Only treat a score as trailing if it appears at the end.
    # Avoid greedily consuming the team name.
    text.match(/\s+(#{SCORE_RE})\s*\z/x)
  end

  def emit_score(value, offset)
    type = value.match?(/\A\d{1,2}-\d{1,2}\z/) ? :SCORE : :SCORE_FULL
    emit(type, value, offset)
  end
end
