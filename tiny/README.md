# Tiny Football.TXT

the idea - like tiny (or nano) basic - is a tiny subset of
the football.TXT format

why?

- to make it easier to get started writing your own lexer & parser
- to make it easier to expiriment with format extensions & variants
- to make it easier to use a.i. coding agents to generate your own lexer & parser



tips & tricks

- try to use a lexer and use / follow use the "official" tokens
  such as (TEAM/TEAM_NAME, VS, SCORE, etc.)


## format

match block formats:

```
1a) home vs away
1b) home vs away 2-1
1c) home vs away 2-1 (1-0)    ## or 2-1 aet
                              ## or 2-1 aet (1-1, 0-0)
                              ## or 2-2 a.e.t. (1-1, 0-0), 5-4 pen.
2a) home - away
2b) home 2-1 away
2c) home 2-1 (1-0) away
```

- 1b & 2b)   ->  SCORE  ("generic / plain")
- 1c & 3c)   ->  SCORE_FULL

possible team separators in match block:
- v    => VS
- -   => TEAM_SEP
- 2-1 => SCORE
- 2-1 => SCORE_FULL 1-0




## prompts

starting from scratch (zero)?

q: hello. can you generate a tiny (subset) of the football.txt lexer & parser in ruby?


## todos

- [ ]  add sample match fixtures and results