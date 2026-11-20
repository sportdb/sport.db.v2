###
## q: hello. can you generate a tiny (subset)
##          of the football.txt lexer & parser in ruby?
##
## ---
##
##  Would you like to expand this subset to support any of the following?
##  - Level 2 syntax (line-ups, substitutions, yellow/red cards, or penalty shootouts)
##  - Stateful context tracking (nesting matches inside Round and Date objects instead of a flat node stream)
##  - JSON/SQLite serialization from the parsed tree




## a: Here is a self-contained, zero-dependency Ruby lexer and parser
#    for a core subset of the Football.TXT format.

require 'strscan'
require 'pp'

# 1. TOKENS & AST NODES
Token = Data.define(:type, :value, :line)

RoundNode = Data.define(:name)
DateNode  = Data.define(:date)
MatchNode = Data.define(:time, :team1, :score, :team2, :venue, :goals)

# 2. LEXER (Line-by-line tokenizer using StringScanner)
class FootballLexer
  def tokenize(text)
    tokens = []

    text.each_line.with_index(1) do |raw_line, line_num|
      # Strip comments (# ...) and whitespace
      line = raw_line.sub(/#.*$/, '').strip
      next if line.empty?

      s = StringScanner.new(line)

      # Rule 1: Round Header (starts with '::' or '▪')
      if s.scan(/(?:▪|::)\s*(.+)/)
        tokens << Token.new(:ROUND, s[1].strip, line_num)

      # Rule 2: Date Header (e.g., [Fri Aug/15] or [2025-08-15])
      elsif s.scan(/\[([^\]]+)\]/)
        tokens << Token.new(:DATE, s[1].strip, line_num)

      # Rule 3: Goal Scorers Line (enclosed in parentheses)
      elsif s.scan(/\((.+)\)/)
        tokens << Token.new(:GOALS, s[1].strip, line_num)

      # Rule 4: Match Line
      else
        # Optional kickoff time (e.g., 20.00 or 20:00)
        if s.scan(/(\d{1,2}[:.]\d{2})\s+/)
          tokens << Token.new(:TIME, s[1], line_num)
        end

        # Extract optional venue at the end (@ Stadium Name)
        rest = s.rest
        venue = nil
        if rest =~ /\s+@\s+(.+)$/
          venue = $1.strip
          rest = rest.sub(/\s+@\s+.+$/, '')
        end

        # Split teams around score (e.g., 2-1, 1-1 (0-0)) or fixture separator ('v' / 'vs')
        if rest =~ /^(.+?)\s+(\d+-\d+(?:\s*\(\d+-\d+\))?)\s+(.+)$/
          tokens << Token.new(:TEAM, $1.strip, line_num)
          tokens << Token.new(:SCORE, $2.strip, line_num)
          tokens << Token.new(:TEAM, $3.strip, line_num)
        elsif rest =~ /^(.+?)\s+(?:v|vs\.?)\s+(.+)$/i
          tokens << Token.new(:TEAM, $1.strip, line_num)
          tokens << Token.new(:VS, 'v', line_num)
          tokens << Token.new(:TEAM, $2.strip, line_num)
        else
          raise SyntaxError, "Line #{line_num}: Unrecognized syntax -> #{line}"
        end

        tokens << Token.new(:VENUE, venue, line_num) if venue
      end
    end

    tokens << Token.new(:EOF, nil, -1)
    tokens
  end
end

# 3. PARSER (Recursive Descent)
class FootballParser
  def initialize(tokens)
    @tokens = tokens
    @pos = 0
  end

  def parse
    ast = []
    until current.type == :EOF
      case current.type
      when :ROUND
        ast << RoundNode.new(consume(:ROUND).value)
      when :DATE
        ast << DateNode.new(consume(:DATE).value)
      when :TIME, :TEAM
        ast << parse_match
      else
        raise SyntaxError, "Line #{current.line}: Unexpected token #{current.type}"
      end
    end
    ast
  end

  private

  def parse_match
    time  = current.type == :TIME ? consume(:TIME).value : nil
    team1 = consume(:TEAM).value

    score = if current.type == :SCORE
              consume(:SCORE).value
            else
              consume(:VS)
              nil
            end

    team2 = consume(:TEAM).value
    venue = current.type == :VENUE ? consume(:VENUE).value : nil
    goals = current.type == :GOALS ? parse_goals(consume(:GOALS).value) : []

    MatchNode.new(time:, team1:, score:, team2:, venue:, goals:)
  end

  # Splits "(Saka 24', Havertz 74'; Bowen 55')" into home & away scorer arrays
  def parse_goals(raw_goals)
    home_part, away_part = raw_goals.split(';').map(&:strip)
    {
      home: home_part && !home_part.empty? ? home_part.split(',').map(&:strip) : [],
      away: away_part && !away_part.empty? ? away_part.split(',').map(&:strip) : []
    }
  end

  def current
    @tokens[@pos]
  end

  def consume(expected_type)
    tok = current
    unless tok.type == expected_type
      raise SyntaxError, "Line #{tok.line}: Expected #{expected_type}, got #{tok.type}"
    end
    @pos += 1
    tok
  end
end



###
##  TODO/FIX/FIX
##    uses old legacy format
##     change to use latest (standard) format

# 4. EXAMPLE USAGE
sample_data = <<~TXT
  # English Premier League Sample
  :: Matchday 1

  [Fri Aug/15]
    20.00  Liverpool FC          4-2  AFC Bournemouth    @ Anfield
           (Ekitike 37', Gakpo 49'; Semenyo 64', 76')

  [Sat Aug/16]
    15.00  Arsenal FC              v  Wolverhampton Wanderers
TXT

tokens = FootballLexer.new.tokenize(sample_data)
tree   = FootballParser.new(tokens).parse

puts "--- TOKENS ---"
pp tokens

puts "\n--- PARSE TREE ---"
pp tree
