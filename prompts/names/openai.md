
openai chat, aug 3, 2026


## q:


a: Yes. In Ruby (Onigmo regex engine), you can make this much cleaner than the original.

## Requirements

Allow:

```
John Smith
O'Connor
D'Artagnan
McDonald's
Jean-Luc
K.-H.
K.-H. F
St. James'
J.P.
A.
R2-D2
AT&T
Smith/Jones
A+B
```

Reject:

```
---
///
+++
22
22-22
1.-2.
123
```

The tricky part is **rejecting names that consist only of numbers**, while still allowing alphanumeric tokens like `R2-D2` or `Studio54`.

## I'd separate the concerns

Instead of making one enormous regex, require that **at least one letter exists somewhere**.

### Ruby

```ruby
NAME_PATTERN = /
  (?=.*\p{L})                       # at least one Unicode letter

  '?                               # optional leading apostrophe

  [\p{L}\d&+]+                     # first chunk

  (?:
      (?:[.'\/+-][\p{L}\d&+]+)*     # internal punctuation
      \.?                           # optional trailing dot
      '?                            # optional trailing apostrophe
  )

  (?:
      \s+
      [\p{L}\d&+]+
      (?:
          (?:[.'\/+-][\p{L}\d&+]+)*
          \.?
          '?
      )
  )*
$/x
```

The important piece is

```ruby
(?=.*\p{L})
```

which immediately rejects

```
22
22-22
1.-2.
123
```

because there is no letter anywhere.

---

## Even better

I'd define a reusable "name part".

```ruby
NAME_PART = /
    [\p{L}\d&+]+
    (?:[.'\/+-][\p{L}\d&+]+)*
    \.?
    '?
/x

NAME_PATTERN = /
    (?=.*\p{L})
    '?
    #{NAME_PART}
    (?:\s+#{NAME_PART})*
$/x
```

This is much easier to maintain.

---

## Examples

| String         | Match |
| -------------- | :---: |
| `John`         |   ✅   |
| `John Smith`   |   ✅   |
| `St. James'`   |   ✅   |
| `K.-H. F`      |   ✅   |
| `J.P.`         |   ✅   |
| `A.`           |   ✅   |
| `D'Artagnan`   |   ✅   |
| `McDonald's`   |   ✅   |
| `Smith/Jones`  |   ✅   |
| `AT&T`         |   ✅   |
| `R2-D2`        |   ✅   |
| `Studio54`     |   ✅   |
| `54Studio`     |   ✅   |
| `22`           |   ❌   |
| `22-22`        |   ❌   |
| `1.-2.`        |   ❌   |
| `---`          |   ❌   |
| `+++`          |   ❌   |
| `John---Smith` |   ❌   |
| `John///Smith` |   ❌   |
| `John+++Smith` |   ❌   |

### One thing to decide

There's one ambiguity worth resolving: should `A+B` be treated as **one token** (e.g., a business name) or as two tokens joined by `+`? The pattern above treats `+` as an internal character within a name part, so `A+B` matches as a single part. If you'd rather reserve `+` as a separator, that's easy to change.

Overall, I'd recommend **avoiding the original "separator" approach**. Defining a valid **name part** and then matching one or more name parts separated by spaces is much easier to reason about, extend, and test.



## q:  how to exclude  a 2-2  or "keywords" such as a.e.t. or vs e.g. austria vs or rapid a.e.t.?



I think you're reaching the point where **one regex isn't enough**. I'd split it into:

1. **Structural validation** (is it a plausible name?)
2. **Business rules** (reject known non-names)

This is much easier to maintain.

## 1. Excluding scores like `2-2`

The simplest way is a negative lookahead near the beginning:

```ruby
(?!\d+(?:[.-]\d+)+$)
```

This rejects strings consisting entirely of number groups separated by `.` or `-`.

Examples rejected:

```text
2-2
22-22
1.2
1.-2.
12.34
3-1-2
```

while still allowing

```text
R2-D2
Studio54
B2B
```

because they contain letters.

---

## 2. Excluding keywords

Another negative lookahead:

```ruby
(?!(?i:vs|v|a\.e\.t\.|pens?|penalties?)$)
```

or, if you want to reject them only when they are the **last word**:

```ruby
(?<!\S)
(?!(?i:vs|a\.e\.t\.))
```

An easier approach in Ruby is simply:

```ruby
STOP_WORDS = %w[
  vs
  v
  aet
  a.e.t.
  pen
  pens
  penalties
]
```

Then after a regex match:

```ruby
words = name.downcase.split

return false if STOP_WORDS.include?(words.last.delete("."))
```

That is much more readable than embedding everything in regex.

---

## 3. Rejecting

```text
Austria vs
Rapid a.e.t.
Liverpool pens
```

is very easy afterwards:

```ruby
STOP_WORDS = /\A(?:vs|v|a\.?e\.?t\.?|pens?|penalties)\z/i

last = name.split.last

return false if last.match?(STOP_WORDS)
```

Notice this accepts

```text
AET Construction Ltd
```

because the last word is `Ltd`, not `AET`.

---

## 4. My preferred solution

I'd make the regex responsible only for **shape**:

```ruby
NAME_PATTERN = /\A
  (?=.*\p{L})                    # at least one letter
  (?!\d+(?:[.-]\d+)+\z)          # not only numeric score/range
  ...
\z/x
```

and then apply business rules:

```ruby
return false if name.split.last.match?(/\A(?:vs|v|a\.?e\.?t\.?|pens?)\.?\z/i)
return false if name.match?(/\A\d+(?:[.-]\d+)+\z/)
```

This is much easier to extend later with things like:

```ruby
FT
HT
ET
AET
Aban.
Postp.
Cancelled
Live
U19
U21
Women
Reserves
```

without turning the regex into something that's nearly impossible to read.

I generally recommend keeping the regex focused on "does this look like a name?" and handling domain-specific exclusions (football abbreviations, score formats, etc.) as separate checks. That separation tends to produce code that's both more robust and easier to maintain.
