#  fbtxt-parser - football.txt match parser

## Usage


``` ruby
result = Fbtxt.parse( txt )   # returns Fbtxt::ParserResult w/ tree, errors/ok?/nok?/etc.


#-or-

parser = Fbtxt::Parser.new(txt)
tree, errors = parser.parse_with_errors
```


note - for porcelain / higher-level apis see `Fbtxt::Document`,
for low-level lexer see `Fbtxt::Lexer`.
