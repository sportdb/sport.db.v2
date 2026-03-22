####
#  to run use:
#    $ ruby sandbox/test_empty.rb

$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'

## try empty doc



### check tokenizer - 
#    note -  text input gets preprocessed
##           e.g. removes comments, empty lines etc (by default)!!!!
  puts "tokenize:"
  parser = RaccMatchParser.new( '' )
  pp parser.next_token

  puts "parse:"
  parser = RaccMatchParser.new( '' )
  tree = parser.parse
  pp tree


  ###########
  ## check with spaces
  puts "tokenize:"
  parser = RaccMatchParser.new( '   ' )
  pp parser.next_token

  puts "parse:"
  parser = RaccMatchParser.new( '   ' )
  tree = parser.parse
  pp tree


  ############
  ## check with empty line
  puts "tokenize:"
  parser = RaccMatchParser.new( "\n" )
  pp parser.next_token

  puts "parse:"
  parser = RaccMatchParser.new( "\n" )
  tree = parser.parse
  pp tree



puts "bye"



__END__

tokenize:
nil
parse:
[]

tokenize:
[:BLANK, "<|BLANK|>"]
parse:
[<BlankLine>]

tokenize:
[:BLANK, "<|BLANK|>"]
parse:
[<BlankLine>]