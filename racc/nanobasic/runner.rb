# runner.rb

require_relative 'tokenizer'    ## fix - change to lexer
require_relative 'parser'


code = <<~BASIC
  10 PRINT "HELLO WORLD"
  20 LET X = 1
  30 PRINT "LOOP NUMBER " + X
  40 LET X = X + 1
  50 IF X < 4 THEN 30
  60 PRINT "DONE!"
BASIC

puts code


begin
  lexer = NanoBasicLexer.new
  tokens = lexer.tokenize(code)
  puts "==> tokens:"
  pp tokens

  parser = NanoBasicParser.new
  ast = parser.parse(tokens)
  puts "==> ast:"
  pp ast

  puts "-----------------------------------"
rescue => e
  puts "An error occurred: #{e.message}"
end


puts "bye"