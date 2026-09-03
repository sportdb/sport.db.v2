
## Notes


### My ranking of the four versions

Having now done all four from scratch, I'd describe them this way:

| Language       | What I like most                                             |
| -------------- | ------------------------------------------------------------ |
| **Ruby**       | Extremely compact and expressive                             |
| **Python**     | Probably the easiest to read                                 |
| **TypeScript** | Best compile-time description of the token model             |
| **Go**         | Best combination of simplicity, explicitness, and robustness |

For a NanoBASIC implementation specifically, **Go might actually be my favorite**.

Not because it's the shortest, but because the lexer becomes almost a direct transcription of the language rules. There is very little magic:

```text
read character
→ recognize construct
→ consume construct
→ emit token
→ repeat
```

And that feels *exactly right* for a tiny language.

One thing I'd change before calling this the definitive Go version, though: **I'd make it `Next()/Token()/Err()` and make token values more strongly typed**, rather than carrying `any`. That would give you a really clean Go-native lexer API suitable for feeding directly into a parser.



---

If I were actually implementing NanoBASIC today, my personal ranking after doing these versions would probably be:

**Rust** → strongest type safety / nicest token model
**Go** → simplest and most idiomatic implementation
**Ruby** → most pleasant regex-oriented implementation
**TypeScript** → excellent if the whole interpreter lives in JS land
**Python** → probably the fastest to prototype

And for a tiny interpreter, I think **Rust + a small regex-assisted scanner** is a particularly sweet spot.


---

### My increasingly ridiculous NanoBASIC language ranking

After these experiments:

| Language             | Lexer personality                        |
| -------------------- | ---------------------------------------- |
| **Ruby**             | Regex poetry                             |
| **Python**           | Pragmatic and friendly                   |
| **JavaScript**       | Surprisingly elegant with sticky regex   |
| **TypeScript**       | Same, but the compiler watches your back |
| **Go**               | Beautifully boring                       |
| **Rust**             | Extremely solid and strongly typed       |
| **Elixir**           | Weirdly delightful                       |
| **NanoBASIC itself** | Obviously the final boss                 |


---

That's probably my favorite **tiny** version.

And the really nice thing about Flex

The source is basically the lexical specification itself:

```text
whitespace       → ignore
apostrophe       → comment
REM              → comment
number           → NUMBER
quoted text      → STRING
identifier       → keyword or VARIABLE
operator         → SYMBOL
newline          → EOL
anything else    → error
```

That's very close to how you'd write the lexical grammar in a language specification.
