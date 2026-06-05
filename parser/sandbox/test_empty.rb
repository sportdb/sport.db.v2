####
#  to run use:
#    $ ruby sandbox/test_empty.rb

$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



def lex( txt )
  tokens, errors = SportDb::Lexer.new( txt, debug: true ).tokenize_with_errors

  if !errors.empty?
     puts "!! errros:"
     pp errors
  end

  tokens
end

def parse( txt )
 tree, errors = RaccMatchParser.new( txt, debug: true ).parse_with_errors

  if !errors.empty?
     puts "!! errros:"
     pp errors
  end

  tree
end


samples = [
  '',
  ' ',      ## check with spaces
  '    ',
  '  # hello ',   ## comment line
  "\n",     ## check with empty line
  "\n\n\n",
  "\r\n\r\n\r\n",
  "   \n \n    \n  ",
]

### check lexer
samples.each_with_index do |txt, i|
  puts
  puts "==> [#{i+1}] lex (tokenize):\n   >#{txt.inspect}<"
  tokens = lex( txt  )
  puts "    resulting in:"
  pp tokens
end

### check parser
samples.each_with_index do |txt, i|
  puts
  puts "==> [#{i+1}] parse:\n   >#{txt.inspect}<"
  tree = parse( txt )
  puts "    resulting in:"
  pp tree
end


puts "bye"


__END__

## note - line.rstrip (right strip)
##                for now (automatically) removes trailing spaces (plus newline)

''                 resulting in:   []
' '                resulting in:   [[<|BLANK|> @1]]
'    '             resulting in:   [[<|BLANK|> @1]]
"\n"               resulting in:   [[<|BLANK|> @1]]
"\n\n\n"           resulting in:   [[<|BLANK|> @1], [<|BLANK|> @2], [<|BLANK|> @3]]
"   \n \n    \n  " resulting in:   [[<|BLANK|> @1], [<|BLANK|> @2], [<|BLANK|> @3], [<|BLANK|> @4]]



''                 resulting in:   []
' '                resulting in:   [<BlankLine>]
'    '             resulting in:   [<BlankLine>]
"\n"               resulting in:   [<BlankLine>]
"\n\n\n"           resulting in:   [<BlankLine>, <BlankLine>, <BlankLine>]
"   \n \n    \n  " resulting in:   [<BlankLine>, <BlankLine>, <BlankLine>, <BlankLine>]
