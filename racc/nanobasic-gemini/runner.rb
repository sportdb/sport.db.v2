# runner.rb

require_relative 'lexer'
require_relative 'parser'
require_relative 'runtime'

nano_code = <<~BASIC
  10 PRINT "HELLO WORLD"
  20 LET X = 1
  30 PRINT "LOOP NUMBER " + X
  40 LET X = X + 1
  50 IF X < 4 THEN 30
  60 PRINT "DONE!"
BASIC

begin
  lexer = NanoBasicLexer.new(nano_code)
  tokens = lexer.tokenize
  puts "==> tokens:"
  pp tokens

  parser = NanoBasicParser.new
  ast = parser.parse(tokens)
  puts "==> ast:"
  pp ast

  puts "--- Executing NanoBASIC Program ---"
  runtime = NanoBasicRuntime.new(ast)
  runtime.run
  puts "-----------------------------------"
rescue => e
  puts "An error occurred: #{e.message}"
end
