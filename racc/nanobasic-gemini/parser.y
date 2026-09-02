# parser.y

class NanoBasicParser

token NUMBER IDENTIFIER STRING LET PRINT GOTO IF THEN EQ PLUS MINUS LT GT EQ_COMP

preclow
  left LT GT EQ_COMP
  left PLUS MINUS
prechigh

rule
  program:
    lines { result = val }

  lines:
    lines line { result = val + [val] }
  | line       { result = [val] }

  line:
    NUMBER statement { result = { line_num: val, stmt: val } }

  statement:
    LET IDENTIFIER EQ expr  { result = { type: :let, var: val, val: val } }
  | PRINT expr              { result = { type: :print, val: val } }
  | GOTO NUMBER             { result = { type: :goto, target: val } }
  | IF expr THEN NUMBER     { result = { type: :if, condition: val, target: val } }

  expr:
    NUMBER                  { result = val }
  | STRING                  { result = val } # Base case: a literal string
  | IDENTIFIER              { result = { type: :variable, name: val } }
  | expr PLUS expr          { result = { type: :add, left: val, right: val } }
  | expr MINUS expr         { result = { type: :sub, left: val, right: val } }
  | expr LT expr            { result = { type: :lt, left: val, right: val } }
  | expr GT expr            { result = { type: :gt, left: val, right: val } }
  | expr EQ_COMP expr       { result = { type: :eq_comp, left: val, right: val } }

end




---- inner
  def parse(tokens)
    @tokens = tokens
    do_parse
  end

  def next_token
    @tokens.shift
  end
