require_relative "lexer"


source = <<~TXT
  # Simple fixtures
  Arsenal v Chelsea
  Liverpool v Everton

  # Scores
  Arsenal v Chelsea 2-1
  Arsenal v Chelsea 2-1 (1-0)

  # Extra time and penalties
  Arsenal v Chelsea 2-2 aet
  Arsenal v Chelsea 2-2 aet (1-1, 0-0), 5-4 pen.

  # Dates and kickoff times
  2025-08-15 Arsenal v Chelsea
  2025-08-15 20:00 Arsenal v Chelsea 2-1
TXT

lexer = NanoFootballLexer.new(source)

lexer.tokenize.each do |token|
  puts token
end