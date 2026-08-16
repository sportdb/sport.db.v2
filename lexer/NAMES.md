
# Names

breaking (tokenizing) text lines into names


---

q: text format. lexer / parser.
    how can i break (tokenize) text lines into names where

- names are more than simple/single words
  and can include dots (.) e.g. U.S.A., St.James, etc.
  or   quotes e.g. B'gladbach

- names can continue if only SINGLE space
  or special characters e.g. -/& or such
    e.g. United States,  Paris-St-Germain, A/B/C, K.-H. Förster

- names CAN include (and start with) digits/numbers BUT
   must ALWAYS include at least one (alphabetic) letter
   e.g. 1 FC Cologne, 1860 Munich, PK-53, Union 1FC Stein, A1, 1A, etc.

- DOUBLE space ALWAYS breaks / ends names
---





a name is more than a word and CAN continue
 with SINGLE space or special characters (e.g. `-/&`) or such.
 note -  words allow letters PLUS  dot (.) & quote (')
           e.g.  U.S.A., St.James', B'gladbach, etc.

 note - DOUBLE space ALWAYS breaks / ends names  !!

more breakable special characters
 -  the brackets `[]`   (reserved for notes)   or
 -  comma, semicolos  `,;` or
 -  colon  `:`     (reserved for properties!!)

note - reserve special handling for parenthesis `()`


the different types of names include:

- TEAM_NAME     -
   e.g.
    note -  will break on v (versus),
              can start with digits or contain digits e.g. 1 FC, PK-32, etc.


- PLAYER_NAME (PERSON/REFEREE/OFFICIAL/etc.) -
   e.g.
     note - CANNOT contain digits/numbers !!!
          K.-H.Rummenige

- GEO_NAME      -   (must start with @)
    note -     allows   _-_, _/_, and more, most liberal
