# parser.y

class NanoBasicParser


preclow
  left '<' '>' '='
  left '+' '-'
prechigh

rule
  program:
    lines { result = val }

  lines:
    line       { result = [val] }
  | lines line { result = val + [val] }


  line:
    NUMBER statement "\n" { result = { line_num: val, stmt: val } }


  statement:
    LET VARIABLE '=' expr  { result = { type: :let, var: val, val: val } }
  | PRINT expr              { result = { type: :print, val: val } }
  | GOTO NUMBER             { result = { type: :goto, target: val } }
  | IF expr THEN NUMBER     { result = { type: :if, condition: val, target: val } }

  expr:
    NUMBER                  { result = val }
  | STRING                  { result = val }      # Base case: a literal string
  | VARIABLE                { result = { type: :variable, name: val } }
  | expr '+' expr          { result = { type: :add, left: val, right: val } }
  | expr '-' expr         { result = { type: :sub, left: val, right: val } }
  | expr '<' expr            { result = { type: :lt, left: val, right: val } }
  | expr '>' expr            { result = { type: :gt, left: val, right: val } }
  | expr '=' expr       { result = { type: :eq_comp, left: val, right: val } }

end




---- inner
  def parse(tokens)
    @tokens = tokens
    do_parse
  end

  def next_token

    tok = @tokens.shift

    ##  convert to racc format single char literal tokens e.g. '@' etc.
    ##                  note - literal token MUST be string (NOT symbol)
    ##    note - racc expects array with to items
    ##               -  item[0] is the token id
    ##               -  item[1] is the token value

    ## note - returns nil for end-of-file !!!
    tok = [tok.type, tok.value]   if tok
  end
