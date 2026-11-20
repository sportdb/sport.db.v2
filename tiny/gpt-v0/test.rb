
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
  "15.08.2025 20:00 Austria - Germany"
]

samples.each do |line|
  puts "\n#{line}"
  FootballLexer.new(line).tokenize.each do |t|
    puts "%-12s %p" % [t.type, t.value]
  end
end
