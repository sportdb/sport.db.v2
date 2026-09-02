
via google ai mode  (sep 2026)

rewrite the nanoBASIC from the book
in ruby using racc for the parser


```
$ racc -o parser.rb parser.y
```


$ ruby runner.rb





--- Executing NanoBASIC Program ---
HELLO WORLD
LOOP NUMBER 1
LOOP NUMBER 2
LOOP NUMBER 3
DONE!
-----------------------------------

but really

--- Executing NanoBASIC Program ---
An error occurred: no implicit conversion of Symbol into Integer


```
  10 PRINT "HELLO WORLD"
  20 LET X = 1
  30 PRINT "LOOP NUMBER " + X
  40 LET X = X + 1
  50 IF X < 4 THEN 30
  60 PRINT "DONE!"


==> tokens:
[[:NUMBER, 10],
 [:PRINT, "PRINT"],
 [:STRING, "HELLO WORLD"],

 [:NUMBER, 20],
 [:LET, "LET"],
 [:IDENTIFIER, "X"],
 [:EQ, "="],
 [:NUMBER, 1],

 [:NUMBER, 30],
 [:PRINT, "PRINT"],
 [:STRING, "LOOP NUMBER "],
 [:PLUS, "+"],
 [:IDENTIFIER, "X"],

 [:NUMBER, 40],
 [:LET, "LET"],
 [:IDENTIFIER, "X"],
 [:EQ, "="],
 [:IDENTIFIER, "X"],
 [:PLUS, "+"],
 [:NUMBER, 1],
 [:NUMBER, 50],
 [:IF, "IF"],
 [:IDENTIFIER, "X"],
 [:LT, "<"],
 [:NUMBER, 4],
 [:THEN, "THEN"],
 [:NUMBER, 30],
 [:NUMBER, 60],
 [:PRINT, "PRINT"],
 [:STRING, "DONE!"],
 [false, false]]
 ```
