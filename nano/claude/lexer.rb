# frozen_string_literal: true

require 'strscan'

# Lexer for the Nano Football.TXT format
# spec: https://openfootball.github.io/spec/nano/
#
# Line oriented. The first characters of a line decide what kind of line it is:
#   #            comment (skipped)
#   = / == / === heading
#   ▪            round
#   YYYY-MM-DD   stand-alone date (only if nothing else follows)
#   otherwise    match line:  date? time? home " v " away score? status? venue?
#
# Token types:
#   :HEADING  [level, text]      :ROUND  text        :DATE  "2025-08-15"
#   :TIME     "20:00"            :TEAM   name        :VS
#   :SCORE    Score struct - the *whole* score (result, aet, FT, HT, pen)
#   :STATUS   text               :VENUE  ["Camp Nou", "Barcelona"]
#   :EOL      end of a (non-blank, non-comment) line

class NanoLexer
  Token = Struct.new(:type, :value, :line, :col) do
    def to_s
      value.nil? ? type.to_s : "#{type}(#{value.inspect})"
    end
  end

  # Everything the nano format can say about a result, in one value:
  #   score - the result as reported, e.g. [2, 2]  (the ET result if aet)
  #   aet   - true if after extra time
  #   ft    - full-time score  [h, a] or nil
  #   ht    - half-time score  [h, a] or nil
  #   pen   - penalty shootout [h, a] or nil
  Score = Struct.new(:score, :aet, :ft, :ht, :pen, keyword_init: true)

  class Error < StandardError; end

  DATE_RE   = /\d{4}-\d{2}-\d{2}/
  TIME_RE   = /\d{1,2}:\d{2}/
  STATUS_RE = /\[([^\]]*)\]/
  HSPACE    = /[ \t]+/

  # The whole score in one regex:
  #
  #   1-1                          2-2 aet (1-1, 0-0), 5-4 pen
  #   1-1 (0-1)                    1-1, 3-4 pen
  #   1-1 aet                      3-4 pen
  #   1-1 aet (1-1)                1-1 FT
  #
  #   main result : r_h-r_a, then optional  aet|FT  and optional ( d1 [, d2] )
  #   penalties   : p_h-p_a pen  (after an optional comma; may stand alone)
  SCORE_RE = /
    (?= \d+ \s* - \s* \d+ )                          # must start with N-N
    (?:
      (?<r_h>\d+) \s* - \s* (?<r_a>\d+)
      (?! \s* (?:pen\.?|p) (?![[:alpha:]]) )         # "N-N pen" = penalties only
      (?: [ \t]+ (?: (?<aet>a\.e\.t\.?|aet) | (?<fulltime>FT) ) (?![[:alpha:]]) )?
      (?:
        [ \t]* \( \s*
          (?<d1_h>\d+) \s* - \s* (?<d1_a>\d+)
          (?: \s* , \s* (?<d2_h>\d+) \s* - \s* (?<d2_a>\d+) )?
        \s* \)
      )?
    )?
    (?:
      (?: [ \t]* , [ \t]* | [ \t]+ )?
      (?<p_h>\d+) \s* - \s* (?<p_a>\d+) [ \t]* (?:pen\.?|p) (?![[:alpha:]])
    )?
  /xi

  # a team name runs up to " v " (home) or up to the first score / [status] /
  # @venue / # comment / end of line (away)
  HOME_RE = /.+?(?=[ \t]+v[ \t]+)/
  AWAY_RE = /.+?(?=[ \t]+(?:\d+\s*-\s*\d+|\[|@|\#)|[ \t]*$)/

  def initialize(text)
    @text = text
  end

  def tokens
    @tokens = []
    @text.each_line.with_index(1) do |raw, lineno|
      lex_line(raw.chomp, lineno)
    end
    @tokens
  end

  alias lex tokens

  private

  def emit(type, value = nil)
    @tokens << Token.new(type, value, @lineno, @ss.pos + 1)
  end

  def lex_line(line, lineno)
    @lineno = lineno
    @ss = StringScanner.new(line)
    @ss.skip(HSPACE)

    return if @ss.eos?          # blank line
    return if @ss.check(/#/)    # comment line

    if @ss.scan(/(={1,6})[ \t]*/)       # heading: = / == / ===
      level = @ss[1].length
      emit :HEADING, [level, rest_of_line]
    elsif @ss.skip(/▪[ \t]*/)           # round
      emit :ROUND, rest_of_line
    elsif @ss.check(/#{DATE_RE}[ \t]*(?:#.*)?$/)  # stand-alone date
      emit :DATE, @ss.scan(DATE_RE)
      @ss.terminate
    else
      lex_match
    end

    emit :EOL
  end

  def rest_of_line
    text = @ss.rest.strip
    @ss.terminate
    text
  end

  # ---- match line ---------------------------------------------------------

  def lex_match
    if @ss.check(DATE_RE)
      emit :DATE, @ss.scan(DATE_RE)
      @ss.skip(HSPACE)
    end
    if @ss.check(/#{TIME_RE}(?![\d])/)
      emit :TIME, @ss.scan(TIME_RE)
      @ss.skip(HSPACE)
    end

    home = @ss.scan(HOME_RE) or error("expected '<home> v <away>'")
    emit :TEAM, home.strip
    @ss.skip(HSPACE)
    @ss.skip(/v/) or error("expected 'v'")
    emit :VS
    @ss.skip(HSPACE)

    away = @ss.scan(AWAY_RE) or error("expected away team")
    emit :TEAM, away.strip

    lex_match_tail
  end

  # score / status / venue
  def lex_match_tail
    until @ss.eos?
      @ss.skip(HSPACE)
      break if @ss.eos?

      if @ss.scan(SCORE_RE)
        emit :SCORE, build_score
      elsif @ss.scan(STATUS_RE)
        emit :STATUS, @ss[1].strip
      elsif @ss.skip(/@[ \t]*/)
        emit :VENUE, venue_geo_tree
      elsif @ss.check(/#/)    # trailing comment
        @ss.terminate
      else
        error("unexpected #{@ss.peek(10).inspect}")
      end
    end
  end

  # turn the named captures of SCORE_RE into a Score
  def build_score
    pair = ->(h, a) { @ss[h] && [@ss[h].to_i, @ss[a].to_i] }

    result = pair.(:r_h, :r_a)
    aet    = !@ss[:aet].nil?
    d1     = pair.(:d1_h, :d1_a)
    d2     = pair.(:d2_h, :d2_a)

    # parens hold (FT, HT) after aet or when two pairs are given;
    # a single pair without aet is the half-time score
    ft, ht = (aet || d2) ? [d1, d2] : [nil, d1]
    ft ||= result if @ss[:fulltime] || (result && !aet && !@ss[:p_h].nil?)

    Score.new(score: result, aet: aet, ft: ft, ht: ht, pen: pair.(:p_h, :p_a))
  end

  # "@ Camp Nou, Barcelona" => ["Camp Nou", "Barcelona"]
  # venue runs to end of line (or a trailing # comment / [status])
  def venue_geo_tree
    text = @ss.scan(/[^#\[]*/)
    text.split(',').map(&:strip).reject(&:empty?)
  end

  def error(msg)
    raise Error, "line #{@lineno}, col #{@ss.pos + 1}: #{msg} in #{@ss.string.inspect}"
  end
end
