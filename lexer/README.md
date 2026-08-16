#  fbtxt-lexer - football.txt match lexer (& tokenizer)


## Usage


``` ruby
result = Fbtxt.lex( txt )     # returns Fbtxt::LexerResult  w/ tokens, errors/ok?/nok?/etc.


#-or-

lexer = Fbtxt::Lexer.new(txt)
tokens, errors = lexer.tokenize_with_errors
```


note - for porcelain / higher-level apis see `Fbtxt::Document`.
