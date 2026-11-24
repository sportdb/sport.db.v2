require_relative 'lexer'

  sample = <<~TXT
    = Champions League

    ▪ Quarter-finals - 1st Leg
    2024-04-01
      20:45   FC Barcelona        v Atlético Madrid    1-1  @ Camp Nou, Barcelona
      20:45   Manchester United   v Bayern München     1-1  @ Old Trafford, Manchester
    2024-04-02
      20:45   Real Madrid         v Borussia Dortmund  3-0  @ Santiago Bernabéu, Madrid

    # comment
    Arsenal v Chelsea 2-2 aet (1-1, 0-0), 5-4 pen
    2025-08-15 20:00 Arsenal v Chelsea 2-1 (1-0)
    Arsenal v Chelsea 1-1, 3-4 pen
    Arsenal v Chelsea 3-4 pen
    Arsenal v Chelsea 1-1 aet
    Arsenal v Chelsea [postponed]
    Arsenal v Chelsea 3-0 [awarded]   # inline comment
    Club#1 v Club#2 1-0
  TXT

  src = ARGV[0] ? File.read(ARGV[0]) : sample

  NanoLexer.new(src).tokens.each do |t|
    puts "#{t.line.to_s.rjust(3)}  #{t}"
  end
