
# racc Samples



## racc Notes

<https://martinfowler.com/bliki/HelloRacc.html>




## NanoBASIC (smaller TinyBASIC variant) Notes

orginal (in python) in David Kopec's Computer Science from Scratch book

> An interpreter for Nano BASIC, a dialect of Tiny BASIC - a programming language
> that was used during the personal computer revolution.

see <https://github.com/davecom/ComputerScienceFromScratch/tree/main/NanoBASIC>


The NanoBASIC grammar is a modified version of the TinyBASIC grammar.

Some items have been removed from the original Tiny BASIC grammar to simplify the language even further. Notably INPUT and the accompanying var-list. As well as REPL control statements like CLEAR, LIST, RUN, and END. Also all non-comment lines must start with a number. Note that the literal COMMENT in the below can be any text of any kind


formal grammar:

```
line ::= number statement \n | REM COMMENT \n

statement ::= PRINT expr-list
              IF expression relop expression THEN statement
              GOTO expression
              LET var = expression
              GOSUB expression
              RETURN

expr-list ::= (string|expression) (, (string|expression) )*

expression ::= (-|ε) term ((+|-) term)*

term ::= factor ((*|/) factor)*

factor ::= var | number | (expression)

var ::= A | B | C ... | Y | Z

number ::= digit digit*

digit ::= 0 | 1 | 2 | 3 | ... | 8 | 9

relop ::= < (>|=|ε) | > (<|=|ε) | =

string ::= " (a|b|c ... |x|y|z|A|B|C ... |X|Y|Z|digit)* "
```




## TinyBASIC Notes

<https://en.wikipedia.org/wiki/Tiny_BASIC>

The overall design for Tiny BASIC (by Dennis Allison) was published in the September 1975 issue of the People's Computer Company (PCC) newsletter


formal grammar   (CR = Carriage Return)

```
line ::= number statement CR | statement CR

    statement ::= PRINT expr-list
                  IF expression relop expression THEN statement
                  GOTO expression
                  INPUT var-list
                  LET var = expression
                  GOSUB expression
                  RETURN
                  CLEAR
                  LIST
                  RUN
                  END

    expr-list ::= (string|expression) (, (string|expression) )*

    var-list ::= var (, var)*

    expression ::= (+|-|ε) term ((+|-) term)*

    term ::= factor ((*|/) factor)*

    factor ::= var | number | (expression)

    var ::= A | B | C ... | Y | Z

    number ::= digit digit*

    digit ::= 0 | 1 | 2 | 3 | ... | 8 | 9

    relop ::= < (>|=|ε) | > (<|=|ε) | =

    string ::= " ( |!|#|$ ... -|.|/|digit|: ... @|A|B|C ... |X|Y|Z)* "
```


<https://github.com/pankuznetsov/Palo-Alto-BASIC-in-Ruby-less-then-in-500-lines>
  <https://github.com/pankuznetsov/Palo-Alto-BASIC-in-Ruby-less-then-in-500-lines/blob/master/paloaltobasic.rb>

<https://github.com/katsuyoshi/tiny_basic_by_ruby>

more

<https://gotbasic.com/tiny.html>
<https://github.com/eddavis2/Tiny-Basic>
<http://tinybasic.cyningstan.org.uk/>
  <http://tinybasic.cyningstan.org.uk/page/12/tiny-basic-manual>
  <http://tinybasic.cyningstan.org.uk/downloads/7/games-in-basic>

<http://www.ittybittycomputers.com/IttyBitty/TinyBasic/index.htm>
<http://www.ittybittycomputers.com/IttyBitty/TinyBasic/TBuserMan.htm>
<http://www.ittybittycomputers.com/IttyBitty/TinyBasic/ProgTB/ProgTB0.htm>

<https://github.com/kevinthecheung/tiny-basic>


tinybasic.de

<https://www.tinybasic.de/>
<https://www.tinybasic.de/language.htm>
<https://www.tinybasic.de/samples.htm>
<https://www.tinybasic.de/download/TinyBasic.pdf>



## More Basics

PyBasic
- <https://github.com/richpl/PyBasic>
   - <https://github.com/richpl/PyBasic/blob/master/basictoken.py>
   - <https://github.com/richpl/PyBasic/blob/master/lexer.py>
   - <https://github.com/richpl/PyBasic/tree/master/examples>

Basic (Classic Game) Examples
- <https://github.com/coding-horror/basic-computer-games>
