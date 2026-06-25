# Football.TXT Formats (Ideas) Log

## 2026
### Thu Jun 25
- [ ] add back support for tables BUT
      only allow/check for table headers (e.g. ` P W D L ...`) to start off tables
      until blank line (or possible notabene/NB: ??)

e.g.
```
               P  W  D  L   Gls  Pts
BRAZIL         3  2  1  0   5- 2   7
PORTUGAL       3  1  2  0   7- 0   5
Côte d'Ivoire  3  1  1  1   4- 3   4
North Korea    3  0  0  3   1-12   0


NOTE - in new "style" requires table header

 1.SOLOMON I.    1  1  0  0  3- 1  3
 2.TAHITI        1  0  0  1  1- 3  0
 -.Cook Islands  [withdrew after first match (annulled) due to Covid-19 outbreak in squad]
 -.Vanuatu       [withdrew before playing any matches due to Covid-19 outbreak in squad]

change to
                 P  W  D  L   Gls  Pts
 1.SOLOMON I.    1  1  0  0  3- 1  3
 2.TAHITI        1  0  0  1  1- 3  0
 -.Cook Islands  [withdrew after first match (annulled) due to Covid-19 outbreak in squad]
 -.Vanuatu       [withdrew before playing any matches due to Covid-19 outbreak in squad]
```

parser note - to make live for the lexer easier
it's a best practice (good idea)
to have line markers that "tag" the type of line or structure e.g.
  `P  W  D  L   Gls  Pts` acts like  a "classic"-keyword like `class`, `struct`, `int`
or such.

note - allow (possibly) different variant of table headers.
