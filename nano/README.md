# Nano Football.TXT

find the format write-up/readme/docu
@ <https://openfootball.github.io/spec/nano>


## updates / todos

- [ ] list match status vocabulary

- [ ] yes, add support for ` - ` separator too


- [ ] define/use a regex for the score
- [ ] define/use home and away team names


## more commentary

```
The end of the away team is a guess.
The home team is easy because v delimits it. The away team ends wherever the score, status, venue or end of line starts, so the lexer needs a lookahead heuristic (.+? up to \d+-\d+, [, @, #). That works for real data but isn't in the spec.
The cheapest fix is one sentence reserving characters: a team name must not contain [, @, #, or whitespace followed by N-N. That would turn the heuristic into a rule.


The grammar doesn't match the examples.

The grammar defines result_details := N-N details but never defines details.
Examples like 3-4 pen (no main result) and 1-1, 3-4 pen aren't derivable from it.

The heading rule shows only "=", but the prose allows == and ===.

The prose says only line-start # comments exist,
but the score examples use trailing # ... comments.
Is a mid-line # a comment or part of a name?


The meaning of parentheses depends on a flag.
In 1-1 aet (1-1, 0-0) the parentheses mean (FT, HT), but in 1-1 (0-1) they mean (HT). The main score is the latest in time, and the details run backwards. A lexer can handle this (I did it in the score regex), but the parser needs a special case, and readers have to remember the rule.



6. Several lexical basics are missing.

Encoding: ▪ (U+25AA) is non-ASCII, hard to type and easy to confuse with similar characters. Say "UTF-8, BOM tolerated".
Whitespace: the samples indent match lines, so say that leading and trailing whitespace is ignored.
Spacing and dashes: is 1 - 1 allowed? Is an en dash 1–1 allowed? Pick one.
Case: is V or vs allowed? Is AET allowed?
Rounds: add an ASCII alternative such as > or ::.


7. Date and time semantics are undefined.

Does a stand-alone date header apply to all following matches until the next header?
Does a match with its own date override it?
What time zone are times in: venue-local, UTC, or unspecified? A match with a time but no date at all is also unaddressed.
The standalone date line has to be told apart from a match line that starts with a date, which needs lookahead to the end of the line.

8. The geo tree order is unspecified. The only example is Camp Nou, Barcelona, which is specific-to-general. Is that guaranteed? Does a trailing country count as part of the tree?



How to make it easier without losing the nano feel
Split the grammar into lexical and syntactic levels. The lexical level would list the tokens (DATE, TIME, TEXT, SCORE, STATUS, VENUE) with exact regexes, and the syntactic level would say how they combine. The one-regex score token is a good candidate, and the spec could publish it.
Ship a machine-readable test corpus. The site title says "Spec (& Tests)" but the nano page has none. A directory of input.txt plus expected.json pairs, including invalid inputs, would help implementers more than any prose.
Bless an optional column separator. The samples already align fields with runs of spaces. Saying "two or more spaces or a tab always ends a field" would let aligned files lex without lookahead, and compact one-space files would still work through the reserved-character rule.
```