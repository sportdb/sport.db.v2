
require_relative "lexer"

samples = [
  "Austria v Germany",
  "Austria v Germany 2-1",
  "Austria v Germany 2-1 (1-0)",
  "Austria v Germany 2-1 aet",
  "Austria v Germany 2-1 aet (1-1, 0-0)",
  "Austria v Germany 2-2 a.e.t. (1-1, 0-0), 5-4 pen.",
  "Austria - Germany",
  "Austria 2-1 Germany",
  "Austria 2-1 (1-0) Germany",
  "Fri Aug 15 20:00 Austria v Germany 2-1 (1-0)",
  "2025-08-15 20:00 Austria v Germany 2-1",
  "15.08.2025 20:00 Austria - Germany",

  "2025-08-15 20:00 Manchester United v Bayern München 2-2 a.e.t. (1-1, 0-0), 5-4 pen.",
  "2025-08-15 20:00 Arsenal v Chelsea 2-1",


  "Arsenal v Chelsea",      #	TEAM VS TEAM
  "Arsenal v Chelsea 2-1", #	TEAM VS TEAM SCORE
  "Arsenal v Chelsea 2-1 (1-0)", #	TEAM VS TEAM SCORE_FULL
  "Arsenal v Chelsea 2-1 aet", #	TEAM VS TEAM SCORE_FULL
  "Arsenal v Chelsea 2-1 aet (1-1, 0-0)", #	TEAM VS TEAM SCORE_FULL
  "Arsenal v Chelsea 2-2 a.e.t. (1-1, 0-0), 5-4 pen.", #	TEAM VS TEAM SCORE_FULL

  "Arsenal - Chelsea",    #	TEAM TEAM_SEP TEAM
  "Arsenal 2-1 Chelsea",  #	TEAM SCORE TEAM
  "Arsenal 2-1 (1-0) Chelsea",  #	TEAM SCORE_FULL TEAM

]

samples.each do |line|
  puts "\n#{line}"
  FootballLexer.new(line).lex.each do |t|
    puts "%-12s %p (offset %d)" % [t.type, t.value, t.offset]
  end
end
