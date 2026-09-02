
q:  please, do a lexer torture-test review


 I re-read the **current published version** and there is one important issue I would fix before doing anything else: the torture tests expose a fundamental interaction between `TOKEN_RE.match(line, pos)` and the fact that the regexp is **not anchored at `pos`**. ([GitHub][1])

## 🔥 The big one: the lexer can skip characters

You currently have:

```ruby
m = TOKEN_RE.match(line, pos)
```

The subtlety is that Ruby's `Regexp#match(string, pos)` means essentially:

> find the next match **at or after** `pos`

It does **not** mean:

> match must start exactly at `pos`.

That is particularly dangerous because your regex has no `\G` anchor.

### Torture test #1

```basic
10 XPRINT
```

What should happen?

Probably:

```text
NUMBER   "10"
VARIABLE "XPRINT"
```

But at the position where `XPRINT` begins, the regex can skip the `X` and find:

```text
PRINT
```

inside `XPRINT`.

Because `PRINT\b` matches the `PRINT` suffix, the lexer can identify it as a `KEYWORD`.

That's a serious lexer bug.

---

### Even worse

Try:

```basic
10 @ PRINT
```

At `pos == 0` after the `10`/whitespace, there is an illegal `@`.

Your `ANY` rule is supposed to catch it.

But `TOKEN_RE.match(line, pos)` is allowed to search forward and can find `PRINT` later in the line.

So the lexer can effectively say:

> "I couldn't find a token here, but hey, there's a PRINT over there!"

That's exactly what a lexer must **never** do.

And there's an additional problem: you advance with:

```ruby
pos += m[0].length
```

rather than using the actual match start.

So once the regex has skipped forward, your `pos` no longer corresponds to where the match actually occurred.

---

# Fix: `\G`

This is precisely the situation where Ruby's `\G` anchor is useful.

I'd change the construction to make the entire token regexp begin with:

```ruby
\G
```

For example:

```ruby
TOKEN_RE = Regexp.union(
  %r{\G (?<COMMENT> rem \b .*) }ix,
  ...
)
```

But there's a wrinkle: because you're using `Regexp.union`, I'd actually prefer putting the anchor **outside** the alternatives:

```ruby
TOKEN_RE = Regexp.union(
  %r{(?<COMMENT> rem \b .*)}ix,
  %r{(?<WHITESPACE> [ \t\n\r])}x,
  ...
)

TOKEN_RE = /\G#{TOKEN_RE}/
```

Now:

```ruby
TOKEN_RE.match(line, pos)
```

can only succeed if the token begins **exactly at `pos`**.

That gives your final:

```ruby
(?<ANY> . )
```

a very important property:

> if no legitimate token starts here, `ANY` catches exactly this character.

That's a solid lexer architecture.

---

# My torture-test matrix

Here's what I'd throw at the lexer.

| Input           | Expected                         | Why                                    |
| --------------- | -------------------------------- | -------------------------------------- |
| `PRINT`         | `PRINT`                          | basic keyword                          |
| `print`         | `PRINT`                          | case insensitive                       |
| `PRINTX`        | `VARIABLE`                       | keyword boundary                       |
| `XPRINT`        | `VARIABLE`                       | **catches unanchored regex**           |
| `REMARK`        | `VARIABLE`                       | REM boundary                           |
| `XREM`          | `VARIABLE`                       | **catches unanchored regex**           |
| `REM hello`     | comment                          | comment                                |
| `X REM hello`   | variable + comment               | comment position                       |
| `123`           | NUMBER                           | basic number                           |
| `-123`          | NUMBER currently                 | unary-minus decision                   |
| `1-2`           | NUMBER MINUS NUMBER              | **minus ambiguity**                    |
| `1--2`          | NUMBER MINUS NUMBER              | parser territory                       |
| `1<>2`          | NUMBER NOT_EQUAL NUMBER          | longest operator                       |
| `1<=2`          | NUMBER LESS_EQUAL NUMBER         | longest operator                       |
| `1<2`           | NUMBER LESS NUMBER               | ordinary operator                      |
| `1>=2`          | NUMBER GREATER_EQUAL NUMBER      | longest operator                       |
| `1>2`           | NUMBER GREATER NUMBER            | ordinary operator                      |
| `A+B`           | VARIABLE PLUS VARIABLE           | no whitespace                          |
| `(A)`           | OPEN_PAREN VARIABLE CLOSE_PAREN  | punctuation                            |
| `""`            | STRING with `""` text/value `""` | empty string                           |
| `"hello"`       | STRING                           | ordinary string                        |
| `"hello world"` | STRING                           | whitespace inside string               |
| `"hello"X`      | STRING VARIABLE                  | adjacent tokens                        |
| `X"hello"`      | VARIABLE STRING                  | adjacent tokens                        |
| `"hello`        | error                            | unterminated string                    |
| `@`             | syntax error                     | `ANY`                                  |
| `A@B`           | error at `@`                     | **mustn't skip it**                    |
| `@PRINT`        | error at `@`                     | **mustn't skip to PRINT**              |
| `123@456`       | error at `@`                     | **mustn't skip it**                    |
| `PRINT @ X`     | error at `@`                     | same                                   |
| `IFX`           | VARIABLE                         | keyword boundary                       |
| `XIF`           | VARIABLE                         | **unanchored-match test**              |
| `THENX`         | VARIABLE                         | keyword boundary                       |
| `GOTO123`       | VARIABLE                         | keyword boundary                       |
| `GOTO 123`      | KEYWORD NUMBER                   | normal                                 |
| `REM`           | comment                          | comment-only line                      |
| `REMX`          | variable                         | important                              |
| `XREM Y`        | variable + variable?             | **important**                          |
| `_`             | VARIABLE                         | currently allowed                      |
| `ABC_123`       | VARIABLE NUMBER                  | because `_`/digits aren't both allowed |
| `123ABC`        | NUMBER VARIABLE                  | current language choice                |

The bold ones are the ones I'd particularly want in automated tests.

---

# There's another interesting discovery

Your `VARIABLE` is:

```ruby
(?<VARIABLE> [A-Za-z_]+ )
```

So:

```basic
ABC123
```

becomes:

```text
VARIABLE "ABC"
NUMBER   "123"
```

rather than:

```text
VARIABLE "ABC123"
```

That's not necessarily wrong — **but it needs to be a deliberate NanoBASIC rule**.

Likewise:

```basic
A1
```

becomes:

```text
VARIABLE "A"
NUMBER "1"
```

If you're modelling classic TinyBASIC, that's actually potentially reasonable because many old BASIC dialects had very restricted variable names. But if you intend modern-ish identifiers, you'd probably want:

```ruby
[A-Za-z_][A-Za-z0-9_]*
```

I'd leave it alone for now unless your language specification says otherwise.

---

# Strings: mostly good, one design question

Current:

```ruby
%r{ (?<STRING> ".*?") }x
```

Good test:

```basic
PRINT "HELLO " + "WORLD"
```

It should produce two STRING tokens.

It does.

But:

```basic
PRINT "HELLO" "WORLD"
```

also produces two adjacent strings. That's okay for the lexer; whether it's legal belongs to the parser.

The interesting one is:

```basic
PRINT "HELLO
```

Because your `STRING` doesn't match, `ANY` eventually catches the `"`. So you get a syntax error rather than a specific "unterminated string" error.

**For nanoBASIC, I'd actually be happy with that.** You don't need to over-engineer error reporting yet.

---

# `REM` deserves special attention

This:

```ruby
(?<COMMENT> rem \b .*)
```

has a nice property:

```text
REM hello
```

→ comment

while:

```text
REMARK
```

→ variable

because `REM` isn't followed by a word boundary.

But again, without `\G`:

```text
XREM hello
```

is dangerous.

The regex can find `REM` beginning at character 1.

So this is another very good regression test.

---

# Operator torture test

I'd definitely add this little monster:

```basic
10 IF A<>B THEN 20
20 IF A<=B THEN 30
30 IF A>=B THEN 40
40 IF A<B THEN 50
50 IF A>B THEN 60
```

Your ordering is good:

```ruby
NOT_EQUAL
LESS_EQUAL
LESS
GREATER_EQUAL
GREATER
```

so `<>`, `<=`, and `>=` get consumed before their one-character prefixes. ([GitHub][1])

That's exactly what you want.

---

# One thing I would *not* change yet

The `named_captures(...).compact` machinery we discussed earlier?

**Leave it alone.**

After looking at the lexer as a whole, I don't think that deserves attention compared with anchoring the regexp.

In fact, this:

```ruby
captures = m.named_captures(symbolize_names: true).compact
type = captures.keys[0]
```

is perfectly reasonable for a little experimental BASIC lexer.

The `\G` issue is orders of magnitude more important.

---

# My priority list

I'd make the changes in this order:

### 1. 🔴 Fix anchoring

Use `\G` so the regex can **only match at `pos`**.

This is the one real bug I'd fix immediately.

### 2. 🟠 Decide on negative numbers

I'd still recommend:

```ruby
(?<NUMBER> [0-9]+ )
```

and leave `-` as `MINUS`.

That makes the lexer/parser boundary cleaner.

### 3. 🟡 Decide identifier syntax

Decide whether:

```text
A1
ABC123
```

are valid variable names.

Don't change it merely because another BASIC does it differently.

### 4. 🟢 Add torture tests

Especially:

```text
XPRINT
XREM
@PRINT
A@B
123@456
PRINTX
REMARK
```

Those will protect the lexer from regressions.

---

## And one tiny debugging assertion I'd add

While you're developing this, I'd put:

```ruby
raise "lexer did not match at #{pos}" unless m.begin(0) == pos
```

immediately after the match.

**Before adding `\G`, this assertion will actually expose the bug beautifully.**

After `\G`, it becomes an invariant documenting the fundamental contract of your tokenizer:

> **every match starts exactly where the previous one ended.**

That's a very good invariant for a lexer.

Overall, I like the tokenizer quite a lot. The structure is simple and appropriate for nanoBASIC; I wouldn't turn it into a "proper" lexer framework. But **the `\G` issue is a genuine one**, and the torture tests above are excellent candidates for a tiny regression suite. ([GitHub][1])

[1]: https://github.com/sportdb/sport.db.v2/blob/master/racc/nanobasic/tokenizer.rb "sport.db.v2/racc/nanobasic/tokenizer.rb at master · sportdb/sport.db.v2 · GitHub"
