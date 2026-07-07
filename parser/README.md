#  fbtxt-parser - football.txt match parser (& tokenizer)


## Usage


``` ruby
result = Fbtxt.lex( txt )       # returns Fbtxt::LexerResult w/ tokens, errors/ok?/nok?/etc.
result = Fbtxt.parse( txt )     # returns Fbtxt::ParserResult w/ tree, errors/ok?/nok?/etc.


#-or-

lexer = Fbtxt::Lexer.new(txt)
tokens, errors = lexer.tokenize_with_errors

parser = Fbtxt::Parser.new(txt)
tree, errors = parser.parse_with_errors
```


note - for porcelain / higher-level apis see ``Fbtxt::Document`.
