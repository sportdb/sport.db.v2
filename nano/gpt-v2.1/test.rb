require_relative "lexer"


source = <<~TXT
= Champions League

▪ Quarter-finals - 1st Leg

2024-04-01
20:45 FC Barcelona v Atlético Madrid 1-1 @ Camp Nou, Barcelona
20:45 Manchester United v Bayern München 1-1 @ Old Trafford, Manchester

2024-04-02
20:45 Real Madrid v Borussia Dortmund 3-0 @ Santiago Bernabéu, Madrid

Arsenal v Chelsea  2-2 aet (1-1, 0-0), 5-4 pen
Liverpool v Everton [postponed]

TXT

lexer = NanoLexer.new(source)

lexer.tokenize.each do |token|
  puts token
end
